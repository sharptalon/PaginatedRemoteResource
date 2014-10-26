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

@property (assign, nonatomic) NSUInteger parentItemIndex;
@property (strong, nonatomic) ParentItem *parentItem;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
