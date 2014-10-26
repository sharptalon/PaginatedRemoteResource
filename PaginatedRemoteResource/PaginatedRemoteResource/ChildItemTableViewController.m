//
//  ChildItemTableViewController.m
//  PaginatedRemoteResource
//
//  Created by Mark A. Kolb on 10/25/14.
//  Copyright (c) 2014 Sharp Talon. All rights reserved.
//

#import "ChildItemTableViewController.h"
#import "DetailViewController.h"
#import "ParentItem.h"
#import "ChildItem.h"

#import "AppDelegate.h"
#import "ItemCache.h"
#import "ChildItemRemoteResource.h"


@implementation ChildItemTableViewController

#pragma mark - Properties

@synthesize parentItemIndex = _parentItemIndex;
@synthesize parentItem = _parentItem;
@synthesize detailViewController = _detailViewController;


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [self setupResourceManagementFor:[[ChildItemRemoteResource alloc] initWithTotalItemCount:500 parent:self.parentItem]
                     itemCountGetter:^NSUInteger{
                         AppDelegate *app = [UIApplication sharedApplication].delegate;
                         NSUInteger childCount;
                         if ([app.itemCache lookupChildCountOfParentWithIndex:self.parentItemIndex count:&childCount]) {
                             return childCount;
                         }
                         return 0;
                     }
                     itemCountSetter:^(NSUInteger totalItemCount) {
                         AppDelegate *app = [UIApplication sharedApplication].delegate;
                         [app.itemCache setChildCount:totalItemCount forParentWithIndex:self.parentItemIndex];
                     }
                   indexedItemGetter:^NSObject *(NSUInteger index) {
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       return [app.itemCache getChildItem:index ofParentWithIndex:self.parentItemIndex];
                   }
                   indexedItemSetter:^(NSUInteger index, NSObject *item) {
                       AppDelegate *app = [UIApplication sharedApplication].delegate;
                       [app.itemCache setChildItem:(ChildItem *)item withIndex:index forParentWithIndex:self.parentItemIndex];
                   }
                 cellReuseIdentifier:@"ChildItemCell"];
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Children of %@", self.parentItem.name];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self action:@selector(scrollToBottom:)];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        ChildItem *object = [app.itemCache getChildItem:indexPath.row ofParentWithIndex:self.parentItemIndex];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Actions

- (IBAction)scrollToBottom:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSUInteger childCount;
    if ([app.itemCache lookupChildCountOfParentWithIndex:self.parentItemIndex count:&childCount]) {
        NSInteger lastRow = childCount - 1;
        if (lastRow > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

@end
