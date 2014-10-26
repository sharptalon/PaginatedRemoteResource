//
//  ChildItemRemoteResource.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "MockPaginatedRemoteResource.h"

@class ParentItem;

@interface ChildItemRemoteResource : MockPaginatedRemoteResource

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount parent:(ParentItem *)parent;

@end
