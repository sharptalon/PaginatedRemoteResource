//
//  PaginatedRemoteResource.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PaginatedRemoteResourceBlock)(BOOL wasSuccessful, NSArray *fetchItems, NSInteger totalItemCount);

@protocol PaginatedRemoteResource <NSObject>

- (void)fetchItemsStartingAt:(NSUInteger)offset withLimit:(NSUInteger)limit completion:(PaginatedRemoteResourceBlock)completion;

@end

