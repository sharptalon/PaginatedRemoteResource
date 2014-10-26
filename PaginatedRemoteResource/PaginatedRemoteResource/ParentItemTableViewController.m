//
//  MasterViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ParentItemTableViewController.h"
#import "ChildItemTableViewController.h"
#import "ParentItemTableViewCell.h"
#import "ParentItem.h"

#import "AppDelegate.h"
#import "ItemCache.h"
#import "ParentItemRemoteResource.h"

@interface ParentItemTableViewController ()

@property (strong, nonatomic) ParentItemRemoteResource *parentsRemoteResource;

@end


@implementation ParentItemTableViewController

#pragma mark - View Controller Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    self.parentsRemoteResource = [[ParentItemRemoteResource alloc] initWithTotalItemCount:45];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChild"]) {
        ChildItemTableViewController *childItemTVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        ParentItem *object = [app.itemCache getParentItem:indexPath.row];
        childItemTVC.parentItem = object;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    return app.itemCache.parentItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ParentItem *object = [app.itemCache getParentItem:indexPath.row];
    ParentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentItemCell" forIndexPath:indexPath];
    [cell populateFor:object];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ParentItem *object = [app.itemCache getParentItem:indexPath.row];
    return (object != nil);
}

@end
