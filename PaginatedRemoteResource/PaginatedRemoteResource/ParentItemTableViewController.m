//
//  MasterViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemTableViewController.h"
#import "ChildItemTableViewController.h"
#import "ParentItemTableViewCell.h"
#import "ParentItem.h"

#import "AppDelegate.h"
#import "ItemCache.h"
#import "ParentItemRemoteResource.h"

#define FETCH_PARENT_ITEMS_LIMIT 25

@interface ParentItemTableViewController ()

@property (strong, nonatomic) ParentItemRemoteResource *parentsRemoteResource;

@end


@implementation ParentItemTableViewController

#pragma mark - View Controller Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    self.parentsRemoteResource = [[ParentItemRemoteResource alloc] initWithTotalItemCount:365];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self action:@selector(scrollToBottom:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Fetch first batch of items
    [self fetchItemsStartingAt:0];
}


#pragma mark - Data Fetching

- (void)fetchItemsStartingAt:(NSInteger)offset
{
    [self.parentsRemoteResource fetchItemsStartingAt:offset
                                           withLimit:FETCH_PARENT_ITEMS_LIMIT
                                          completion:^(BOOL wasSuccessful, NSArray *fetchedItems, NSInteger totalItemCount) {
                                              if (wasSuccessful) {
                                                  AppDelegate *app = [UIApplication sharedApplication].delegate;
                                                  app.itemCache.parentItemCount = totalItemCount;
                                                  NSInteger index = offset;
                                                  for (ParentItem *item in fetchedItems) {
                                                      [app.itemCache setParentItem:item forIndex:index++];
                                                  }
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.tableView reloadData];
                                                  });
                                              }
                                          }];
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    return app.itemCache.parentItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ParentItem *object = [app.itemCache getParentItem:indexPath.row];
    ParentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentItemCell" forIndexPath:indexPath];
    if (object) {
        [cell populateFor:object];
    }
    else {
        [cell populateAsLoading];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ParentItem *object = [app.itemCache getParentItem:indexPath.row];
    return (object != nil);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSInteger minimumNonCachedIndex = -1;
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleRow in visibleRows) {
        NSInteger visibleIndex = visibleRow.row;
        ParentItem *object = [app.itemCache getParentItem:visibleIndex];
        if (object == nil) {
            if ((visibleIndex < minimumNonCachedIndex) || (minimumNonCachedIndex < 0)) {
                minimumNonCachedIndex = visibleIndex;
            }
        }
    }
    if (minimumNonCachedIndex >= 0) {
        [self fetchItemsStartingAt:minimumNonCachedIndex];
    }
}

@end
