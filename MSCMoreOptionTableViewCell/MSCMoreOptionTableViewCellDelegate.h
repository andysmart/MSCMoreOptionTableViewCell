//
//  MSCMoreOptionTableViewCellDelegate.h
//  MSCMoreOptionTableViewCell
//
//  Created by Manfred Scheiner (@scheinem) on 20.08.13.
//  Copyright (c) 2013 Manfred Scheiner (@scheinem). All rights reserved.
//

@protocol MSCMoreOptionTableViewCellDelegate<NSObject>

@required
- (void)tableView:(UITableView *)tableView actionButtonAtIndex:(NSInteger)index pressedAtIndexPath:(NSIndexPath *)indexPath;

@optional

// "Delete button"

/*
 * If not implemented or returning nil the "Delete" button will have the default backgroundColor.
 */
- (UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * If not implemented or returning nil the "Delete" button will have the default titleColor.
 */
- (UIColor *)tableView:(UITableView *)tableView titleColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * If not implemented or returning nil the "Delete" button will have the default font
 */
- (UIFont *)tableView:(UITableView *)tableView titleFontForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
