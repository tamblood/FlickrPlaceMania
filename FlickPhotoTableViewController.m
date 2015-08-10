//
//  FlickPhotoTableViewController.m
//  Shutterbug
//
//  Created by Tamara L Blood on 7/31/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "FlickPhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "ATopPlaceFlickrPhotosTVC.h"


@interface FlickPhotoTableViewController ()

@end

@implementation FlickPhotoTableViewController

-(void)setPhotos:(NSArray *)photos
{
  _photos = photos;
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id detail = self.splitViewController.viewControllers[1];
  if ([detail isKindOfClass:[UINavigationController class]]) {
    detail = [((UINavigationController *)detail).viewControllers firstObject];
  }
  if ([detail isKindOfClass:[ImageViewController class]]) {
    [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
  
    return cell;
}

#pragma mark - Navigation

-(void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
  ivc.imageUrl = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
  ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
      NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
      if (indexPath) {
        if ([segue.identifier isEqualToString:@"Display Photo"]) {
          if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
          }
        }
      }
    }
    else {
      NSLog(@"error - sender is not kind of class UITableViewCell");
    }
}

@end
