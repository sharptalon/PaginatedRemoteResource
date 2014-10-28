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
#import "ParentItemTableManager.h"
#import "AppDelegate.h"
#import "ItemCache.h"

#include "Constants.h"

@interface ParentItemTableViewController ()

@property (strong, nonatomic) ParentItemTableManager *tableManager;

@end


@implementation ParentItemTableViewController

#pragma mark - Properties

@synthesize tableManager = _tableManager;


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
    [super viewDidLoad];

    self.tableManager = [[ParentItemTableManager alloc] initForTableView:self.tableView];
    self.tableView.dataSource = self.tableManager;
    self.tableView.delegate = self.tableManager;
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
        [childItemTVC setParentItem:object withIndex:index];
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
