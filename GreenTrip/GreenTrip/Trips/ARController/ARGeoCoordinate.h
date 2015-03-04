//
//  ARGeoCoordinate.h
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARCoordinate.h"

@interface ARGeoCoordinate : ARCoordinate{
    
}

@property (nonatomic, retain) CLLocation *geoLocation;

- (id)initWithCoordinate:(CLLocation *)location name:(NSString *)name place:(NSString *)place;
- (id)initWithCoordinateAndOrigin:(CLLocation *)location name:(NSString *)name place:(NSString *)place origin:(CLLocation *)origin;
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first second:(CLLocationCoordinate2D)second;
- (void)calibrateUsingOrigin:(CLLocation *)origin;
@end
