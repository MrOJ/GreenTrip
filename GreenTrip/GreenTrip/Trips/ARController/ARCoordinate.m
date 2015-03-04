//
//  ARCoordinate.m
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import "ARCoordinate.h"

@implementation ARCoordinate

@synthesize name = _name;
@synthesize place = _place;
@synthesize distance = _distance;
@synthesize inclination = _inclination;
@synthesize azimuth = _azimuth;


- (id)initWithRadialDistance:(double)distance inclination:(double)inclination azimuth:(double)azimuth{
    if (self = [super init]) {
        _distance = distance;       //距离
        _inclination = inclination; //倾角
        _azimuth = azimuth;         //方位角
    }
    return self;
}

@end
