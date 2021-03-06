//
//  StandardTableViewCellController.m
//  MSCMoreOptionTableViewCellDemo
//
//  Created by Manfred Scheiner (@scheinem) on 22.08.13.
//  Copyright (c) 2013 Manfred Scheiner (@scheinem). All rights reserved.
//

#import "StandardTableViewCellController.h"
#import "MSCMoreOptionTableViewCell.h"

@interface StandardTableViewCellController () <MSCMoreOptionTableViewCellDelegate>

@end

@implementation StandardTableViewCellController

////////////////////////////////////////////////////////////////////////
#pragma mark - Initializer
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MSCMoreOptionTableViewCell";
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MSCMoreOptionTableViewCell";
    MSCMoreOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MSCMoreOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        more.backgroundColor = [UIColor grayColor];
        [more setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
        [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *extra = [UIButton buttonWithType:UIButtonTypeCustom];
        extra.backgroundColor = [UIColor lightGrayColor];
        [extra setTitle:NSLocalizedString(@"Extra", nil) forState:UIControlStateNormal];
        [extra setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.rightActionButtons = @[more, extra];
    }
    
    cell.textLabel.text = @"Cell";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Called when "DELETE" button is pushed.
    NSLog(@"DELETE button pushed in row at: %@", indexPath.description);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MSCMoreOptionTableViewCellDelegate
////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView actionButtonAtIndex:(NSInteger)index pressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Button pressed at index: %ld indexPath: %@", (long)index, indexPath);
}

@end
