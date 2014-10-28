//
//  RemoteResourceItemTableViewController.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/26/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaginatedRemoteResource.h"

typedef NSUInteger (^ItemCountGetter)();
typedef void (^ItemCountSetter)(NSUInteger totalItemCount);
typedef void (^IndexedItemSetter)(NSUInteger index, NSObject *item);
typedef NSObject *(^IndexedItemGetter)(NSUInteger index);

@interface RemoteResourceItemTableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

- (id)initForTableView:(UITableView *)tableView
          withResource:(id<PaginatedRemoteResource>)paginatedRemoteResource
       itemCountGetter:(ItemCountGetter)itemCountGetter
       itemCountSetter:(ItemCountSetter)itemCountSetter
     indexedItemGetter:(IndexedItemGetter)indexedItemGetter
     indexedItemSetter:(IndexedItemSetter)indexedItemSetter
   cellReuseIdentifier:(NSString *)cellReuseIdentifier;

@end
