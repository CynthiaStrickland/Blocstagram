//
//  ImagesTableTableViewController.m
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/11/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "ImagesTableTableViewController.h"
#import "MediaFullScreenViewController.h"
#import "MediaTableViewCell.h"
#import "DataSource.h"
#import "Media.h"
#import "User.h"
#import "Comment.h"

@interface ImagesTableTableViewController () <MediaTableViewCellDelegate>

@end

@implementation ImagesTableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
        // *********** ADDING PULL TO REFRESH ************


    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[MediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
}

- (void) refreshControlDidFire:(UIRefreshControl *) sender {
    [[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

- (void) infiniteScrollIfNecessary {
    // #3
   NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];

    if (bottomIndexPath && bottomIndexPath.row == [DataSource sharedInstance].mediaItems.count - 1) {
       // The very last cell is on screen
        [[DataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
        if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
            // We know mediaItems changed.  Let's see what kind of change it is.
            int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
            
            if (kindOfChange == NSKeyValueChangeSetting) {
                // Someone set a brand new images array
                [self.tableView reloadData];
            }
            else if (kindOfChange == NSKeyValueChangeInsertion ||
                     kindOfChange == NSKeyValueChangeRemoval ||
                     kindOfChange == NSKeyValueChangeReplacement) {
                // We have an incremental change: inserted, deleted, or replaced images
                
                // Get a list of the index (or indices) that changed
                NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
                
                // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
                NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
                [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPathsThatChanged addObject:newIndexPath];
                }];
                
                // Call `beginUpdates` to tell the table view we're about to make changes
                [self.tableView beginUpdates];
                
                // Tell the table view what the changes are
                if (kindOfChange == NSKeyValueChangeInsertion) {
                    [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                } else if (kindOfChange == NSKeyValueChangeRemoval) {
                    [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                } else if (kindOfChange == NSKeyValueChangeReplacement) {
                    [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                // Tell the table view that we're done telling it about changes, and to complete the animation
                [self.tableView endUpdates];
            }
        }
    }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataSource sharedInstance].mediaItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.mediaItem = [DataSource sharedInstance].mediaItems[indexPath.row];
    
    return cell;
}

//Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Media *item = [DataSource sharedInstance].mediaItems[indexPath.row];
        [[DataSource sharedInstance] deleteMediaItem:item];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view

    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Media *item = [DataSource sharedInstance].mediaItems[indexPath.row];
    return [MediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

#pragma mark - MediaTableViewCellDelegate

- (void) cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView {
    MediaFullScreenViewController *fullScreenVC = [[MediaFullScreenViewController alloc] initWithMedia:cell.mediaItem];

    [self presentViewController:fullScreenVC animated:YES completion:nil];
}

- (void) cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView {
    NSMutableArray *itemsToShare = [NSMutableArray array];

    if (cell.mediaItem.caption.length > 0) {
        [itemsToShare addObject:cell.mediaItem.caption];
    }

    if (cell.mediaItem.image) {
        [itemsToShare addObject:cell.mediaItem.image];
    }

    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

@end
