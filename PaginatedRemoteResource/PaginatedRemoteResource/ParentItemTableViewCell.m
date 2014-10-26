//
//  ParentItemTableViewCell.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemTableViewCell.h"
#import "ParentItem.h"

@implementation ParentItemTableViewCell

#pragma mark - Populating Views

- (void)populateFor:(NSObject *)item
{
    [self.loadingIndicator stopAnimating];
    self.nameLabel.textColor = [UIColor blackColor];
    ParentItem *parentItem = (ParentItem *)item;
    self.nameLabel.text = parentItem.name;
    self.detailLabel.text = parentItem.detail;
}

- (void)populateAsLoading
{
    self.nameLabel.textColor = [UIColor redColor];
    self.nameLabel.text = @"Loading parent item...";
    self.detailLabel.text = @"";
    [self.loadingIndicator startAnimating];
}

@end
