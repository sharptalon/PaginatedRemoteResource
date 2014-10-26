//
//  MockPaginatedRemoteResource.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "PaginatedRemoteResource.h"

typedef NSObject *(^MockPaginatedRemoteResourceItemGeneratorBlock)(NSUInteger itemIndex);

@interface MockPaginatedRemoteResource : NSObject <PaginatedRemoteResource>

@property (assign, nonatomic) NSUInteger totalItemCount;
@property (assign, nonatomic) NSTimeInterval maxDelay;
@property (copy, nonatomic) MockPaginatedRemoteResourceItemGeneratorBlock itemGeneratorBlock;

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount maxDelay:(NSTimeInterval)maxDelay itemGenerator:(MockPaginatedRemoteResourceItemGeneratorBlock)itemGenerator;

@end
