//
//  MockPaginatedRemoteResource.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "MockPaginatedRemoteResource.h"

@implementation MockPaginatedRemoteResource

#pragma mark - Properties

@synthesize totalItemCount = _totalItemCount;
@synthesize maxDelay = _maxDelay;
@synthesize itemGeneratorBlock = _itemGeneratorBlock;


#pragma mark - Initializer

- (id)initWithTotalItemCount:(NSUInteger)totalItemCount maxDelay:(NSTimeInterval)maxDelay itemGenerator:(MockPaginatedRemoteResourceItemGeneratorBlock)itemGenerator
{
    self = [super init];
    if (self) {
        self.totalItemCount = totalItemCount;
        self.maxDelay = maxDelay;
        self.itemGeneratorBlock = itemGenerator;
    }
    return self;
}


#pragma mark - PaginatedRemoteResource

- (void)fetchItemsStartingAt:(NSUInteger)offset withLimit:(NSUInteger)limit completion:(PaginatedRemoteResourceBlock)completion
{
    NSTimeInterval delayInSeconds = [self randomDelay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:limit];
        NSUInteger stop = MIN(offset + limit, self.totalItemCount);
        for (NSUInteger index = offset; index < stop; index++) {
            NSObject *generatedItem = self.itemGeneratorBlock(index);
            [results addObject:generatedItem];
        }
        completion(YES, [NSArray arrayWithArray:results], self.totalItemCount);
    });
}

#define ARC4RANDOM_MAX 0x100000000

- (NSTimeInterval)randomDelay
{
    NSTimeInterval minDelay = (self.maxDelay > 1) ? MAX(1, self.maxDelay/2) : self.maxDelay/2;
    return minDelay +  ((NSTimeInterval)arc4random() / ARC4RANDOM_MAX) * (self.maxDelay - minDelay);
}

@end
