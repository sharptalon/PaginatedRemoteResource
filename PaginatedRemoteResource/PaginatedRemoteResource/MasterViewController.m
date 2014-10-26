//
//  MasterViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "MasterViewController.h"
#import "ChildItemTableViewController.h"
#import "ParentItemTableViewCell.h"
#import "ParentItem.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@end


@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    self.objects =  [[NSMutableArray alloc] initWithArray:@[
                                                            [[ParentItem alloc] initWithName:@"A" detail:@"First"],
                                                            [[ParentItem alloc] initWithName:@"B" detail:@"Second"],
                                                            [[ParentItem alloc] initWithName:@"C" detail:@"Third"],
                                                            [[ParentItem alloc] initWithName:@"D" detail:@"Fourth"],
                                                            [[ParentItem alloc] initWithName:@"E" detail:@"Fifth"],
                                                            ]];
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
        ParentItem *object = self.objects[indexPath.row];
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
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentItemCell" forIndexPath:indexPath];
    ParentItem *object = self.objects[indexPath.row];
    [cell populateFor:object];
    return cell;
}

@end
