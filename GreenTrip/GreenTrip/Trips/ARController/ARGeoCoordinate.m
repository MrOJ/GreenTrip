//
//  ARGeoCoordinate.m
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import "ARGeoCoordinate.h"

@implementation ARGeoCoordinate
@synthesize geoLocation = _geoLocation;   //目标点经纬度

//带来了坐标的名字和位置并设置了基类ARCoordinate的属性，以便在可视化层使用
- (id)initWithCoordinate:(CLLocation *)location name:(NSString *)name place:(NSString *)place {
    if (self = [super init]) {
        self.geoLocation = location;
        // Properties of base class
        self.name = name;
        self.place = place;
    }
    return self;
}

//与initWithCoordinate目的相同，但还允许了一个原点
- (id)initWithCoordinateAndOrigin:(CLLocation *)location name:(NSString *)name place:(NSString *)place origin:(CLLocation *)origin {
    if (self = [super init]) {
        self.geoLocation = location;
        // Properties of base class
        self.name = name;
        self.place = place;
        [self calibrateUsingOrigin:origin];
    }
    return self;
}

//计算介于两点之间的角度的距离
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first second:(CLLocationCoordinate2D)second {
    float longDiff = second.longitude - first.longitude;
    float latDiff = second.latitude - first.latitude;     //就是因为这里导致花费了3天解决bug
    //NSLog(@"first: {%f, %f}",first.latitude,first.longitude);
    //NSLog(@"second: {%f, %f}",second.latitude,second.longitude);
    float aprxAziumuth = (M_PI * .5f) - atan(latDiff / longDiff); //很有可能是方位角的问题，在这里
    //float aprxAziumuth = M_PI  - atan(latDiff / longDiff);
    //NSLog(@"aprxAziumuth is: %f",aprxAziumuth);
    
    if (longDiff > 0) {
        return aprxAziumuth;
    } else if (longDiff < 0) {
        return aprxAziumuth + M_PI;
    } else if (latDiff < 0) {
        return M_PI;
    }
    
    return 0.0f;
}

/*
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first second:(CLLocationCoordinate2D)second {
    float longDiff = second.longitude - first.longitude;
    float latDiff = second.latitude - first.latitude;
    //float aprxAziumuth = atan(latDiff / longDiff);
    //float aprxAziumuth = M_PI  - atan(latDiff / longDiff);
    //NSLog(@"aprxAziumuth is: %f",aprxAziumuth);
    float aprxAziumuth = atan((ABS(latDiff) / ABS(longDiff)));

    if (longDiff > 0 && latDiff >= 0) {
        return aprxAziumuth;
    } else if (longDiff < 0 && latDiff >= 0){
        return M_PI - aprxAziumuth;
    } else if (longDiff < 0 && latDiff < 0){
        return M_PI + aprxAziumuth;
    } else if (longDiff > 0 && latDiff < 0){
        return M_PI * 2.0f - aprxAziumuth;
    } else if (longDiff == 0 && latDiff > 0){
        return M_PI * .5f;
    } else if (longDiff == 0 && latDiff < 0){
        return M_PI * 1.5f;
    }
    
    return 0.0f;
}
*/

//获取介于两点之间的距离（设备和目标点），并计算原距离、角度（考虑属性的变化）以及方位角
- (void)calibrateUsingOrigin:(CLLocation *)origin {
    double baseDistance = [origin distanceFromLocation:_geoLocation];    //设备与目标点的距离
    self.distance = sqrt(pow([origin altitude] - [_geoLocation altitude], 2) + pow(baseDistance, 2));
    float angle = sin(ABS([origin altitude] - [_geoLocation altitude]) / self.distance);
    
    if ([origin altitude] > [_geoLocation altitude]) {
        angle = -angle;
    }
    
    self.inclination = angle;     //计算倾角
    self.azimuth = [self angleFromCoordinate:[origin coordinate] second:[_geoLocation coordinate]]; //计算方位角
}

@end
