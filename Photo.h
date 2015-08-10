//
//  Photo.h
//  FlickrPlacesMania
//
//  Created by Tamara L Blood on 8/5/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSDate * lastViewedDate;
@property (nonatomic, retain) Place *placeTaken;

@end
