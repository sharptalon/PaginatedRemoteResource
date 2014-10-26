//
//  RemoteResourceItemTableViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/26/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "RemoteResourceItemTableViewController.h"
#import "RemoteResourceItemTableViewCell.h"

#define FETCH_ITEMS_LIMIT 25

@interface RemoteResourceItemTableViewController ()

@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (strong, nonatomic) id<PaginatedRemoteResource> paginatedRemoteResource;
@property (copy) ItemCountGetter itemCountGetter;
@property (copy) ItemCountSetter itemCountSetter;
@property (copy) IndexedItemGetter indexedItemGetter;
@property (copy) IndexedItemSetter indexedItemSetter;

@end


@implementation RemoteResourceItemTableViewController

#pragma mark - Properties

@synthesize cellReuseIdentifier = _cellReuseIdentifier;
@synthesize paginatedRemoteResource = _paginatedRemoteResource;


#pragma mark - Initializer

- (void)setupResourceManagementFor:(id<PaginatedRemoteResource>)paginatedRemoteResource
                   itemCountGetter:(ItemCountGetter)itemCountGetter
                   itemCountSetter:(ItemCountSetter)itemCountSetter
                 indexedItemGetter:(IndexedItemGetter)indexedItemGetter
                 indexedItemSetter:(IndexedItemSetter)indexedItemSetter
               cellReuseIdentifier:(NSString *)cellReuseIdentifier
{
    self.paginatedRemoteResource = paginatedRemoteResource;
    self.itemCountGetter = itemCountGetter;
    self.itemCountSetter = itemCountSetter;
    self.indexedItemGetter = indexedItemGetter;
    self.indexedItemSetter = indexedItemSetter;
    self.cellReuseIdentifier = cellReuseIdentifier;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Fetch first batch of items
    [self fetchItemsStartingAt:0];
}


#pragma mark - Data Fetching

- (void)fetchItemsStartingAt:(NSInteger)offset
{
    // NOTE: Need to reload the whole table only when new rows are being added.
    BOOL reloadWholeTable = [self.tableView numberOfRowsInSection:0] < offset + FETCH_ITEMS_LIMIT;
    [self.paginatedRemoteResource fetchItemsStartingAt:offset
                                           withLimit:FETCH_ITEMS_LIMIT
                                          completion:^(BOOL wasSuccessful, NSArray *fetchedItems, NSInteger totalItemCount) {
                                              if (wasSuccessful) {
                                                  self.itemCountSetter(totalItemCount);
                                                  NSMutableArray *pathsToBeReloaded = [NSMutableArray arrayWithCapacity:fetchedItems.count];
                                                  NSInteger index = offset;
                                                  for (NSObject *item in fetchedItems) {
                                                      self.indexedItemSetter(index, item);
                                                      [pathsToBeReloaded addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                      ++index;
                                                  }
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if (reloadWholeTable) {
                                                          [self.tableView reloadData];
                                                      }
                                                      else {
                                                          [self.tableView reloadRowsAtIndexPaths:pathsToBeReloaded withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  });
                                              }
                                          }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemCountGetter();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *object = self.indexedItemGetter(indexPath.row);
    UITableViewCell <RemoteResourceItemTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
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
    NSObject *object = self.indexedItemGetter(indexPath.row);
    return (object != nil);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger minimumNonCachedIndex = -1;
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleRow in visibleRows) {
        NSInteger visibleIndex = visibleRow.row;
        NSObject *object = self.indexedItemGetter(visibleIndex);
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
