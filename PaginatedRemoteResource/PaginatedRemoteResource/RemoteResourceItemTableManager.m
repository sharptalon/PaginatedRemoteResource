//
//  RemoteResourceItemTableViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/26/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "RemoteResourceItemTableManager.h"
#import "RemoteResourceItemTableViewCell.h"

#include "Constants.h"

@interface RemoteResourceItemTableManager ()

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (strong, nonatomic) id<PaginatedRemoteResource> paginatedRemoteResource;
@property (copy) ItemCountGetter itemCountGetter;
@property (copy) ItemCountSetter itemCountSetter;
@property (copy) IndexedItemGetter indexedItemGetter;
@property (copy) IndexedItemSetter indexedItemSetter;

@end


@implementation RemoteResourceItemTableManager

#pragma mark - Properties

@synthesize tableView = _tableView;
@synthesize cellReuseIdentifier = _cellReuseIdentifier;
@synthesize paginatedRemoteResource = _paginatedRemoteResource;


#pragma mark - Initializer

- (id)initForTableView:(UITableView *)tableView
          withResource:(id<PaginatedRemoteResource>)paginatedRemoteResource
       itemCountGetter:(ItemCountGetter)itemCountGetter
       itemCountSetter:(ItemCountSetter)itemCountSetter
     indexedItemGetter:(IndexedItemGetter)indexedItemGetter
     indexedItemSetter:(IndexedItemSetter)indexedItemSetter
   cellReuseIdentifier:(NSString *)cellReuseIdentifier
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.paginatedRemoteResource = paginatedRemoteResource;
        self.itemCountGetter = itemCountGetter;
        self.itemCountSetter = itemCountSetter;
        self.indexedItemGetter = indexedItemGetter;
        self.indexedItemSetter = indexedItemSetter;
        self.cellReuseIdentifier = cellReuseIdentifier;
        [self fetchItemsStartingAt:0];
    }
    return self;
}


#pragma mark - Data Fetching

- (void)fetchItemsStartingAt:(NSInteger)offset
{
    [self.paginatedRemoteResource fetchItemsStartingAt:offset
                                           withLimit:FETCH_ITEMS_LIMIT
                                          completion:^(BOOL wasSuccessful, NSArray *fetchedItems, NSInteger totalItemCount) {
                                              if (wasSuccessful) {
                                                  self.itemCountSetter(totalItemCount);
                                                  NSInteger index = offset;
                                                  for (NSObject *item in fetchedItems) {
                                                      self.indexedItemSetter(index, item);
                                                      ++index;
                                                  }
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.tableView reloadData];
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
