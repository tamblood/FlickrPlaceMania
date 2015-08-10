//
//  Place+Flickr.h
//  FlickrPlacesMania
//
//  Created by Tamara L Blood on 8/5/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "Place.h"

@interface Place (Flickr)

+ (Place *)placeWithFlickrInfo:(NSDictionary *)placeDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadPlacesFromFlickrArray:(NSArray *)places // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context;

@end