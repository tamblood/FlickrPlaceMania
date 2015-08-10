//
//  Photo+Flickr.m
//  Photomania
//
//  Created by Tamara L Blood on 8/4/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
  Photo *photo = nil;
  
  NSString *unique = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
  NSLog(@"unique is %@", unique);
  request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
  
  NSError *error;
  NSArray *matches = [context executeFetchRequest:request error:&error];
  
  if (!matches || error || ([matches count] > 1)) {
    NSLog(@"Error in number or fetching of matches");
  } else if ([matches count]) {
    NSLog(@"photo already in database");
    photo = [matches firstObject];
  } else {
    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                          inManagedObjectContext:context];
    photo.unique = unique;
    photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSLog(@"adding photo to database with title %@", photo.title);
    photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString ];
//    NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
//    photo.whoTook = [Photographer photographerWithName:photographerName inManagedObjectContext:context];

  }
  
  return photo;
  
}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context
{
  NSLog(@"In loadPhotos from flickrArray");
  for (NSDictionary *photo in photos)
  {
    [Photo photoWithFlickrInfo:photo inManagedObjectContext:context];
  }
}

@end
