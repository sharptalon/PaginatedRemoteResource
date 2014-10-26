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

@implementation ChildItemRemoteResource

#pragma mark - Initializer

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount parent:(ParentItem *)parent
{
    self = [super initWithTotalItemCount:totalItemCount maxDelay:3.0
                           itemGenerator:^NSObject *(NSUInteger itemIndex) {
                               ChildItem *item = [[ChildItem alloc] initWithParent:parent
                                                                              name:[NSString stringWithFormat:@"%@-child %lu", parent.name, (unsigned long)itemIndex]
                                                                            detail:@"A child item"];
                               return item;
                           }];
    return self;
}
@end
