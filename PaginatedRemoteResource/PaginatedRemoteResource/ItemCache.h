//
//  ItemCache.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParentItem;
@class ChildItem;

@interface ItemCache : NSObject

- (void)setParentItem:(ParentItem *)parentItem forIndex:(NSUInteger)parentIndex;
- (ParentItem *)getParentItem:(NSUInteger)parentIndex;

- (void)setChildCount:(NSUInteger)childCount forParentWithIndex:(NSUInteger)parentIndex;
- (BOOL)lookupChildCountOfParentWithIndex:(NSUInteger)parentIndex count:(NSUInteger *)count;

- (void)setChildItem:(ChildItem *)childItem withIndex:(NSUInteger)childIndex forParentWithIndex:(NSUInteger)parentIndex;
- (ChildItem *)getChildItem:(NSUInteger)childIndex ofParentWithIndex:(NSUInteger)parentIndex;

@end
