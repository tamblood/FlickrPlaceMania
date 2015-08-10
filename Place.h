//
//  Place.h
//  FlickrPlacesMania
//
//  Created by Tamara L Blood on 8/5/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * stateProvince;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSSet *photos;

@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
