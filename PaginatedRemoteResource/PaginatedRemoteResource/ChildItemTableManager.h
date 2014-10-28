//
//  ChildItemTableManager.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/28/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "RemoteResourceItemTableManager.h"

@class ParentItem;

@interface ChildItemTableManager : RemoteResourceItemTableManager

- (id)initForTableView:(UITableView *)tableView withParentItem:(ParentItem *)parentItem withIndex:(NSUInteger)parentItemIndex;

@end
