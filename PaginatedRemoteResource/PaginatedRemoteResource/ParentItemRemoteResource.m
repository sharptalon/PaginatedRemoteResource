//
//  ParentItemRemoteResource.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemRemoteResource.h"
#import "ParentItem.h"

@implementation ParentItemRemoteResource

#pragma mark - Initializer

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount
{
    self = [super initWithTotalItemCount:totalItemCount maxDelay:2.0
                           itemGenerator:^NSObject *(NSUInteger itemIndex) {
                               ParentItem *item = [[ParentItem alloc] initWithName:[NSString stringWithFormat:@"Parent %lu", (unsigned long)itemIndex]
                                                                            detail:@"A parent item."];
                               return item;
                           }];
    return self;
}

@end
