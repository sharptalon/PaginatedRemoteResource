//
//  ChildItemRemoteResource.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemRemoteResource.h"
#import "ParentItem.h"
#import "ChildItem.h"

#include "Constants.h"

@implementation ChildItemRemoteResource

#pragma mark - Initializer

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount parent:(ParentItem *)parent
{
    self = [super initWithTotalItemCount:totalItemCount maxDelay:CHILD_RESOURCE_MAX_DELAY
                           itemGenerator:^NSObject *(NSUInteger itemIndex) {
                               ChildItem *item = [[ChildItem alloc] initWithParent:parent
                                                                              name:[NSString stringWithFormat:@"%@-Child %lu", parent.name, (unsigned long)itemIndex]
                                                                            detail:@"A child item"];
                               return item;
                           }];
    return self;
}
@end
