//
//  ParentItem.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;

- (id)initWithName:(NSString *)name detail:(NSString *)detail;

@end
