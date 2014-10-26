//
//  DetailViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "DetailViewController.h"
#import "ParentItem.h"
#import "ChildItem.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Properties

- (void)setDetailItem:(ChildItem *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


#pragma mark - Populating Views

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Selected %@, child of %@", self.detailItem.name, self.detailItem.parent.name];
        self.navigationItem.title = [NSString stringWithFormat:@"Child Detail: %@", self.detailItem.name];
    }
}

@end
