//
//  ChildItemTableManager.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/28/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemTableManager.h"
#import "ChildItemRemoteResource.h"
#import "ChildItem.h"
#import "ParentItem.h"
#import "AppDelegate.h"
#import "ItemCache.h"

#include "Constants.h"

@implementation ChildItemTableManager

- (id)initForTableView:(UITableView *)tableView withParentItem:(ParentItem *)parentItem withIndex:(NSUInteger)parentItemIndex
{
    self = [super initForTableView:tableView
                      withResource:[[ChildItemRemoteResource alloc] initWithTotalItemCount:NUMBER_OF_CHILDREN_PER_PARENT parent:parentItem]
                   itemCountGetter:^NSUInteger{
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       NSUInteger childCount;
                       if ([app.itemCache lookupChildCountOfParentWithIndex:parentItemIndex count:&childCount]) {
                           return childCount;
                       }
                       return 0;
                   }
                   itemCountSetter:^(NSUInteger totalItemCount) {
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       [app.itemCache setChildCount:totalItemCount forParentWithIndex:parentItemIndex];
                   }
                 indexedItemGetter:^NSObject *(NSUInteger index) {
                     AppDelegate *app = [UIApplication sharedApplication].delegate;
                     return [app.itemCache getChildItem:index ofParentWithIndex:parentItemIndex];
                 }
                 indexedItemSetter:^(NSUInteger index, NSObject *item) {
                     AppDelegate *app = [UIApplication sharedApplication].delegate;
                     [app.itemCache setChildItem:(ChildItem *)item withIndex:index forParentWithIndex:parentItemIndex];
                 }
               cellReuseIdentifier:@"ChildItemCell"];
    
    return self;
}

@end
