//
//  MSCMoreOptionTableViewCell.m
//  MSCMoreOptionTableViewCell
//
//  Created by Manfred Scheiner (@scheinem) on 20.08.13.
//  Copyright (c) 2013 Manfred Scheiner (@scheinem). All rights reserved.
//

#import "MSCMoreOptionTableViewCell.h"

@interface MSCMoreOptionTableViewCell ()

@property (nonatomic, strong) UIButton *moreOptionButton;
@property (nonatomic, strong) UIScrollView *cellScrollView;

@end

@implementation MSCMoreOptionTableViewCell

////////////////////////////////////////////////////////////////////////
#pragma mark - Life Cycle
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _moreOptionButton = nil;
        _cellScrollView = nil;
        
        [self setupMoreOption];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _moreOptionButton = nil;
        _cellScrollView = nil;
        
        [self setupMoreOption];
    }
    return self;
}

- (void)dealloc {
    [self.cellScrollView.layer removeObserver:self forKeyPath:@"sublayers" context:nil];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject(NSKeyValueObserving)
////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sublayers"]) {
        /*
         * Using '==' instead of 'isEqual:' to compare the layer's delegate and the cell's contentScrollView
         * because it must be the same instance and not an equal one.
         */
        if ([object isKindOfClass:[CALayer class]] && ((CALayer *)object).delegate == self.cellScrollView) {
            for (CALayer *layer in [(CALayer *)object sublayers]) {
                /*
                 * Check if the view is the "swipe to delete" container view.
                 */
                NSString *name = NSStringFromClass([layer.delegate class]);
                if ([name hasPrefix:@"UI"] && [name hasSuffix:@"ConfirmationView"]) {
                    
                    UIView *deleteConfirmationView = layer.delegate;
                    UITableView *tableView = [self tableView];
                    
                    // Try to get "Delete" backgroundColor from delegate
                    if ([self.delegate respondsToSelector:@selector(tableView:backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:)]) {
                        UIButton *deleteConfirmationButton = [self deleteButtonFromDeleteConfirmationView:deleteConfirmationView];
                        if (deleteConfirmationButton) {
                            UIColor *deleteButtonColor = [self.delegate tableView:tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:[tableView indexPathForCell:self]];
                            if (deleteButtonColor) {
                                deleteConfirmationButton.backgroundColor = deleteButtonColor;
                            }
                        }
                    }
                    
                    // Try to get "Delete" titleColor and font from Delegate
                    if ([self.delegate respondsToSelector:@selector(tableView:titleColorForDeleteConfirmationButtonForRowAtIndexPath:)] ||
                        [self.delegate respondsToSelector:@selector(tableView:titleFontForDeleteConfirmationButtonForRowAtIndexPath:)]) {
                        
                        UIButton *deleteConfirmationButton = [self deleteButtonFromDeleteConfirmationView:deleteConfirmationView];
                        if (deleteConfirmationButton) {
                            UIColor *deleteButtonTitleColor = [self.delegate tableView:tableView titleColorForDeleteConfirmationButtonForRowAtIndexPath:[tableView indexPathForCell:self]];
                            UIFont *font = [self.delegate tableView:tableView titleFontForDeleteConfirmationButtonForRowAtIndexPath:[tableView indexPathForCell:self]];
                            
                            for (UIView *label in deleteConfirmationButton.subviews) {
                                if ([label isKindOfClass:[UILabel class]]) {
                                    if (deleteButtonTitleColor) {
                                        [(UILabel*)label setTextColor:deleteButtonTitleColor];
                                    }
                                    if (font) {
                                        [(UILabel*)label setFont:font];
                                    }
                                    
                                    break;
                                }
                            }
                        }
                    }
                    
                    NSArray *buttons = self.rightActionButtons;
                    buttons = [[buttons reverseObjectEnumerator] allObjects];
                    
                    if ([buttons count]) {
                        
                        UIButton *deleteButton = [self deleteButtonFromDeleteConfirmationView:deleteConfirmationView];
                        
                        CGFloat xOffset = 0;
                        CGFloat customWidth = 0;
                        
                        UIView *customActionButtonView = [[UIView alloc] initWithFrame:CGRectZero];
                        customActionButtonView.userInteractionEnabled = YES;
                        
                        for (UIButton *button in buttons) {
                            
                            [button sizeToFit];
                            
                            CGRect frame = button.frame;
                            frame.size.width += 30;
                            frame.size.height = CGRectGetHeight(deleteConfirmationView.frame);
                            frame.origin.y = 0;
                            
                            frame.origin.x = xOffset;
                            button.frame = frame;
                            
                            xOffset += frame.size.width;
                            
                            [deleteConfirmationView addSubview:button];
                            
                            customWidth += CGRectGetWidth(button.frame);
                            
                            [button addTarget:self action:@selector(rightActionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        CGRect customViewFrame = CGRectMake(0, 0, customWidth, CGRectGetHeight(deleteConfirmationView.frame));
                        customActionButtonView.frame = customViewFrame;
                        
                        deleteConfirmationView.backgroundColor = [UIColor greenColor];
                        
                        CGRect rect = deleteConfirmationView.frame;
                        rect.size.width = customWidth + deleteButton.frame.size.width;
                        rect.origin.x = deleteConfirmationView.superview.bounds.size.width - (rect.size.width + deleteButton.frame.size.width);
                        deleteConfirmationView.frame = rect;
                        
                        for (UIButton *button in buttons) {
                            [deleteConfirmationView addSubview:button];
                        }
                    }
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - private methods
////////////////////////////////////////////////////////////////////////

/*
 * Looks for a UIDeleteConfirmationButton in a given UIDeleteConfirmationView.
 * Returns nil if the button could not be found.
 */
- (UIButton *)deleteButtonFromDeleteConfirmationView:(UIView *)deleteConfirmationView {
    for (UIButton *deleteConfirmationButton in deleteConfirmationView.subviews) {
        NSString *name = NSStringFromClass([deleteConfirmationButton class]);
        if ([name hasPrefix:@"UI"] && [name rangeOfString:@"Delete"].length > 0 && [name hasSuffix:@"Button"]) {
            return deleteConfirmationButton;
        }
    }
    return nil;
}

- (void)rightActionButtonPressed:(UIButton *)sender {
    
    NSInteger index = [self.rightActionButtons indexOfObject:sender];
    
    if (self.delegate) {
        [self.delegate tableView:[self tableView]
             actionButtonAtIndex:index
              pressedAtIndexPath:[[self tableView] indexPathForCell:self]];
    }
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while(tableView) {
        if(![tableView isKindOfClass:[UITableView class]]) {
			tableView = tableView.superview;
		}
        else {
            return (UITableView *)tableView;
        }
	}
    return nil;
}

- (void)setupMoreOption {
    /*
     * Look for UITableViewCell's scrollView.
     * Any CALayer found here can only be generated by UITableViewCell's
     * 'initWithStyle:reuseIdentifier:', so there is no way adding custom
     * sublayers before. This means custom sublayers are no problem and
     * don't break MSCMoreOptionTableViewCell's functionality.
     */
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.delegate isKindOfClass:[UIScrollView class]]) {
            _cellScrollView = (UIScrollView *)layer.delegate;
            [_cellScrollView.layer addObserver:self forKeyPath:@"sublayers" options:NSKeyValueObservingOptionNew context:nil];
            break;
        }
    }
}

- (BOOL)isMoreOptionButtonTitleValid:(NSString *)title {
    return title != nil && [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
}

@end
