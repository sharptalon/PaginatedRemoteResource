//
//  ChildItem.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParentItem;

@interface ChildItem : NSObject

@property (strong, nonatomic) ParentItem *parent;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;

- (id)initWithParent:(ParentItem *)parent name:(NSString *)name detail:(NSString *)detail;

@end
