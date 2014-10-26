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

- (void)populateFor:(ParentItem *)item
{
    [self.loadingIndicator stopAnimating];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.text = item.name;
    self.detailLabel.text = item.detail;
}

- (void)populateAsLoading
{
    self.nameLabel.textColor = [UIColor redColor];
    self.nameLabel.text = @"Loading parent item...";
    self.detailLabel.text = @"";
    [self.loadingIndicator startAnimating];
}

@end
