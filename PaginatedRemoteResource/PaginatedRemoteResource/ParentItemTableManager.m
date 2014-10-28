//
//  ParentItemTableManager.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/28/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemTableManager.h"
#import "ParentItemRemoteResource.h"
#import "ParentItem.h"
#import "AppDelegate.h"
#import "ItemCache.h"

#include "Constants.h"

@implementation ParentItemTableManager

- (id)initForTableView:(UITableView *)tableView
{
    self = [super initForTableView:tableView
                      withResource:[[ParentItemRemoteResource alloc] initWithTotalItemCount:NUMBER_OF_PARENTS]
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

    return self;
}

@end
