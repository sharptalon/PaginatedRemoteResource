//
//  ChildItemTableViewCell.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemTableViewCell.h"
#import "ParentItem.h"
#import "ChildItem.h"

@implementation ChildItemTableViewCell

#pragma mark - Populating Views

- (void)populateFor:(NSObject *)item
{
    [self.loadingIndicator stopAnimating];
    self.nameLabel.textColor = [UIColor blackColor];
    ChildItem *childItem = (ChildItem *)item;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", childItem.name];
    self.detailLabel.text = childItem.detail;
}

- (void)populateAsLoading
{
    self.nameLabel.textColor = [UIColor redColor];
    self.nameLabel.text = @"Loading parent item...";
    self.detailLabel.text = @"";
    [self.loadingIndicator startAnimating];
}

@end
