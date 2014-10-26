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

- (void)populateFor:(ChildItem *)item
{
    if (item) {
        [self.loadingIndicator stopAnimating];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = [NSString stringWithFormat:@"%@, child of %@", item.name, item.parent.name];
        self.detailLabel.text = item.detail;
    }
    else {
        self.nameLabel.textColor = [UIColor redColor];
        self.nameLabel.text = @"Loading parent item...";
        self.detailLabel.text = @"";
        [self.loadingIndicator startAnimating];
    }
}

@end
