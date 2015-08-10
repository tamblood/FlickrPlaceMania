//
//  Place+Flickr.m
//  FlickrPlacesMania
//
//  Created by Tamara L Blood on 8/6/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//
#import "Place+Flickr.h"
#import "FlickrFetcher.h"
#import "Place.h"

@implementation Place (Flickr)

+ (Place *)placeWithFlickrInfo:(NSDictionary *)placeDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
  Place *place = nil;
    
  NSString *placeId = [placeDictionary valueForKeyPath:FLICKR_PLACE_ID];
    
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
  NSLog(@"placeId is %@", placeId);
  request.predicate = [NSPredicate predicateWithFormat:@"placeId = %@", placeId];
    
  NSError *error;
  NSArray *matches = [context executeFetchRequest:request error:&error];
    
  if (!matches || error || ([matches count] > 1)) {
    NSLog(@"Error in number or fetching of matches");
  } else if ([matches count]) {
    NSLog(@"place already in database");
      place = [matches firstObject];
  } else {
    place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                            inManagedObjectContext:context];
    place.placeId = placeId;
    place.city = [placeDictionary valueForKeyPath:FLICKR_PLACE_CITY];
    NSLog(@"adding place to database with city %@", place.city);
    
    NSString *placeName = [placeDictionary valueForKeyPath:FLICKR_PLACE_NAME];
    place.country = [FlickrFetcher getCountryNameFromFlickrPlaceName:placeName];
    place.stateProvince = [FlickrFetcher getStateNameFromFlickrPlaceName:placeName];
    
  }
  
  return place;
}

+ (void)loadPlacesFromFlickrArray:(NSArray *)places // of Flickr NSDictionary
intoManagedObjectContext:(NSManagedObjectContext *)context
{
  for (NSDictionary *place in places)
  {
    [Place placeWithFlickrInfo:place inManagedObjectContext:context];
  }
  
}

@end

