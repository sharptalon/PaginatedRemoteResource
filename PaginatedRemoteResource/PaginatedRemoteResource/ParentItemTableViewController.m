//
//  MasterViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemTableViewController.h"
#import "ChildItemTableViewController.h"
#import "ParentItem.h"

#import "AppDelegate.h"
#import "ItemCache.h"
#import "ParentItemRemoteResource.h"

#include "Constants.h"

@implementation ParentItemTableViewController

#pragma mark - View Controller Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self action:@selector(scrollToBottom:)];
}

- (void)viewDidLoad
{
    [self setupResourceManagementFor:[[ParentItemRemoteResource alloc] initWithTotalItemCount:NUMBER_OF_PARENTS]
                     itemCountGetter:^NSUInteger{
                         AppDelegate *app = [UIApplication sharedApplication].delegate;
                         return app.itemCache.parentItemCount;
                     }
                     itemCountSetter:^(NSUInteger totalItemCount) {
                         AppDelegate *app = [UIApplication sharedApplication].delegate;
                         [app.itemCache setParentItemCount:totalItemCount];
                     }
                   indexedItemGetter:^NSObject *(NSUInteger index) {
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       return [app.itemCache getParentItem:index];
                   }
                   indexedItemSetter:^(NSUInteger index, NSObject *item) {
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       [app.itemCache setParentItem:(ParentItem *)item forIndex:index];
                   }
                 cellReuseIdentifier:@"ParentItemCell"];
    [super viewDidLoad];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChild"]) {
        ChildItemTableViewController *childItemTVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSUInteger index = indexPath.row;
        ParentItem *object = [app.itemCache getParentItem:index];
        childItemTVC.parentItemIndex = index;
        childItemTVC.parentItem = object;
    }
}


#pragma mark - Actions

- (IBAction)scrollToBottom:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSInteger lastRow = app.itemCache.parentItemCount - 1;
    if (lastRow > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
