//
//  ChildItemTableViewController.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentItem;
@class DetailViewController;

@interface ChildItemTableViewController : UITableViewController

@property (assign, nonatomic, readonly) NSUInteger parentItemIndex;
@property (strong, nonatomic, readonly) ParentItem *parentItem;

- (void)setParentItem:(ParentItem *)parentItem withIndex:(NSUInteger)parentItemIndex;

@end
