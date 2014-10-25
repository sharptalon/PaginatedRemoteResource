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

- (void)populate:(ParentItem *)item
{
    self.nameLabel.text = item.name;
    self.detailLabel.text = item.detail;
}

@end
