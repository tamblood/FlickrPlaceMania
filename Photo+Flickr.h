//
//  Photo+Flickr.h
//  Photomania
//
//  Created by Tamara L Blood on 8/4/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
