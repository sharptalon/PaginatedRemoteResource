//
//  ChildItemTableViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemTableViewController.h"
#import "DetailViewController.h"
#import "ChildItemTableViewCell.h"
#import "ParentItem.h"
#import "ChildItem.h"

#import "AppDelegate.h"
#import "ItemCache.h"
#import "ChildItemRemoteResource.h"

#define FETCH_PARENT_ITEMS_LIMIT 25

@interface ChildItemTableViewController ()

@property (strong, nonatomic) ChildItemRemoteResource *childrenRemoteResource;

@end


@implementation ChildItemTableViewController

#pragma mark - Properties

@synthesize parentItemIndex = _parentItemIndex;
@synthesize parentItem = _parentItem;
@synthesize detailViewController = _detailViewController;


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.childrenRemoteResource = [[ChildItemRemoteResource alloc] initWithTotalItemCount:500 parent:self.parentItem];
    self.navigationItem.title = [NSString stringWithFormat:@"Children of %@", self.parentItem.name];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self action:@selector(scrollToBottom:)];
    // Fetch first batch of items
    [self fetchItemsStartingAt:0];
}


#pragma mark - Data Fetching

- (void)fetchItemsStartingAt:(NSInteger)offset
{
    [self.childrenRemoteResource fetchItemsStartingAt:offset
                                           withLimit:FETCH_PARENT_ITEMS_LIMIT
                                          completion:^(BOOL wasSuccessful, NSArray *fetchedItems, NSInteger totalItemCount) {
                                              if (wasSuccessful) {
                                                  AppDelegate *app = [UIApplication sharedApplication].delegate;
                                                  [app.itemCache setChildCount:totalItemCount forParentWithIndex:self.parentItemIndex];
                                                  NSInteger index = offset;
                                                  for (ChildItem *item in fetchedItems) {
                                                      [app.itemCache setChildItem:item withIndex:index++ forParentWithIndex:self.parentItemIndex];
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
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        ChildItem *object = [app.itemCache getChildItem:indexPath.row ofParentWithIndex:self.parentItemIndex];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Actions

- (IBAction)scrollToBottom:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSUInteger childCount;
    if ([app.itemCache lookupChildCountOfParentWithIndex:self.parentItemIndex count:&childCount]) {
        NSInteger lastRow = childCount - 1;
        if (lastRow > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSUInteger childCount;
    if ([app.itemCache lookupChildCountOfParentWithIndex:self.parentItemIndex count:&childCount]) {
        return childCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ChildItem *object = [app.itemCache getChildItem:indexPath.row ofParentWithIndex:self.parentItemIndex];
    ChildItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildItemCell" forIndexPath:indexPath];
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
    ChildItem *object = [app.itemCache getChildItem:indexPath.row ofParentWithIndex:self.parentItemIndex];
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
        ChildItem *object = [app.itemCache getChildItem:visibleIndex ofParentWithIndex:self.parentItemIndex];
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
