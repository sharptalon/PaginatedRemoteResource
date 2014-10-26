//
//  ChildItemTableViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemTableViewController.h"
#import "DetailViewController.h"
#import "ChildItemTableViewCell.h"
#import "ParentItem.h"
#import "ChildItem.h"

@interface ChildItemTableViewController ()

@property NSMutableArray *objects;

@end


@implementation ChildItemTableViewController

#pragma mark - Properties

@synthesize parentItem = _parentItem;
@synthesize detailViewController = _detailViewController;


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.objects =  [[NSMutableArray alloc] initWithArray:@[
                                                            [[ChildItem alloc] initWithParent:self.parentItem name:@"A" detail:@"First"],
                                                            [[ChildItem alloc] initWithParent:self.parentItem name:@"B" detail:@"Second"],
                                                            [[ChildItem alloc] initWithParent:self.parentItem name:@"C" detail:@"Third"],
                                                            [[ChildItem alloc] initWithParent:self.parentItem name:@"D" detail:@"Fourth"],
                                                            [[ChildItem alloc] initWithParent:self.parentItem name:@"E" detail:@"Fifth"],
                                                            ]];
    self.navigationItem.title = [NSString stringWithFormat:@"Children of %@", self.parentItem.name];
}


#pragma mark - Table view data source

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
    ChildItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildItemCell" forIndexPath:indexPath];    
    ChildItem *object = self.objects[indexPath.row];
    [cell populateFor:object];
    return cell;
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ChildItem *object = self.objects[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

@end
