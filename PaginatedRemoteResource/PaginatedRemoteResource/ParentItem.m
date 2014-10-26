//
//  ParentItem.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItem.h"

@implementation ParentItem

#pragma mark - Properties

@synthesize name = _name;
@synthesize detail = _detail;


#pragma mark - Initializer

- (id)initWithName:(NSString *)name detail:(NSString *)detail
{
    self = [super init];
    if (self) {
        self.name = name;
        self.detail = detail;
    }
    return self;
}

@end
