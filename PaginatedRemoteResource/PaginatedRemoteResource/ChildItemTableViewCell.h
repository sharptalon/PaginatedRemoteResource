//
//  ChildItemTableViewCell.h
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "RemoteResourceItemTableViewCell.h"

@class ChildItem;

@interface ChildItemTableViewCell : UITableViewCell  <RemoteResourceItemTableViewCell>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
