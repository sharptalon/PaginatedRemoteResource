//
//  RemoteResourceItemTableViewCell.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/26/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PaginatedRemoteResourceBlock)(BOOL wasSuccessful, NSArray *fetchItems, NSInteger totalItemCount);

@protocol RemoteResourceItemTableViewCell <NSObject>

- (void)populateFor:(NSObject *)item;
- (void)populateAsLoading;

@end

