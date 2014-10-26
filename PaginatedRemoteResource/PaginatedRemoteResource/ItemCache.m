//
//  ItemCache.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ItemCache.h"

@interface ItemCache ()

@property (strong, nonatomic) NSCache *parentItemCache;
@property (strong, nonatomic) NSCache *childCountCache;
@property (strong, nonatomic) NSCache *childItemCaches;

@end


@implementation ItemCache

#pragma mark - Properties

@synthesize parentItemCount = _parentItemCount;
@synthesize parentItemCache = _parentItemCache;
@synthesize childCountCache = _childCountCache;
@synthesize childItemCaches = _childItemCaches;


#pragma mark - Initializer

- (id)init
{
    self = [super init];
    if (self) {
        self.parentItemCount = 0;
        self.parentItemCache = [[NSCache alloc] init];
        self.childCountCache = [[NSCache alloc] init];
        self.childItemCaches = [[NSCache alloc] init];
    }
    return self;
}


#pragma mark - Caching Parent Items

- (void)setParentItem:(ParentItem *)parentItem forIndex:(NSUInteger)parentIndex
{
    [self.parentItemCache setObject:parentItem forKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
    if (parentIndex >= self.parentItemCount) {
        self.parentItemCount = parentIndex + 1;
    }
}

- (ParentItem *)getParentItem:(NSUInteger)parentIndex
{
    return [self.parentItemCache objectForKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
}

#pragma mark - Caching Child Counts

- (void)setChildCount:(NSUInteger)childCount forParentWithIndex:(NSUInteger)parentIndex
{
    [self.childCountCache setObject:[NSNumber numberWithUnsignedInteger:childCount] forKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
}

- (BOOL)lookupChildCountOfParentWithIndex:(NSUInteger)parentIndex count:(NSUInteger *)count
{
    NSNumber *boxedCount = [self.parentItemCache objectForKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
    if (boxedCount) {
        *count = [boxedCount unsignedIntegerValue];
        return YES;
    }
    return NO;
}

#pragma mark - Caching Child Items

- (void)setChildItem:(ChildItem *)childItem withIndex:(NSUInteger)childIndex forParentWithIndex:(NSUInteger)parentIndex
{
    NSCache *childItemCache = [self.childItemCaches objectForKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
    if (childItemCache == nil) {
        childItemCache = [[NSCache alloc] init];
        [self.childItemCaches setObject:childItemCache forKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
    }
    [childItemCache setObject:childItem forKey:[NSNumber numberWithUnsignedInteger:childIndex]];
}

- (ChildItem *)getChildItem:(NSUInteger)childIndex ofParentWithIndex:(NSUInteger)parentIndex
{
    NSCache *childItemCache = [self.childItemCaches objectForKey:[NSNumber numberWithUnsignedInteger:parentIndex]];
    if (childItemCache) {
        return [childItemCache objectForKey:[NSNumber numberWithUnsignedInteger:childIndex]];
    }
    return nil;
}

@end
