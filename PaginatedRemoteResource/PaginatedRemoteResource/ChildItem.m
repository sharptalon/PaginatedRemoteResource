//
//  ChildItem.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItem.h"
#import "ParentItem.h"

@implementation ChildItem

#pragma mark - Properties

@synthesize parent = _parent;
@synthesize name = _name;
@synthesize detail = _detail;


#pragma mark - Initializer

- (id)initWithParent:(ParentItem *)parent name:(NSString *)name detail:(NSString *)detail
{
    self = [super init];
    if (self) {
        self.parent = parent;
        self.name = name;
        self.detail = detail;
    }
    return self;
}

@end
