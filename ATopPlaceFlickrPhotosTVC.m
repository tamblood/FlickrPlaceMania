//
//  ATopPlaceFlickrPhotosTVC.m
//  Shutterbug2
//
//  Created by Tamara L Blood on 8/2/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "ATopPlaceFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface ATopPlaceFlickrPhotosTVC ()

@end

@implementation ATopPlaceFlickrPhotosTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self fetchPhotos];
}

- (void)fetchPhotos
{
  NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.flickrPlaceId maxResults:self.maxResults];
  NSData *jsonResults = [NSData dataWithContentsOfURL:url];
  NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                      options:0
                                                                      error:NULL];
  NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];  
  
  self.photos = photos;
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
