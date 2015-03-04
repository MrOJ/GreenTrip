//
//  ARCoordinate.h
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARAnnotation;

@interface ARCoordinate : NSObject{
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *place;
@property (nonatomic) double distance;
@property (nonatomic) double inclination;
@property (nonatomic) double azimuth;
@property (nonatomic, retain) ARAnnotation *annotation;

- (id)initWithRadialDistance:(double)distance inclination:(double)inclination azimuth:(double)azimuth;

@end
