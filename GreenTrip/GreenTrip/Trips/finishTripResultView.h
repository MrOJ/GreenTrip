//
//  finishTripResultView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/19.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "YDConfigurationHelper.h"

#import <ShareSDK/ShareSDK.h>

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface finishTripResultView : UIView <ISSShareViewDelegate>{
    NSString *consumeCalStr;
    NSString *reduceCarbonStr;
}

@property (nonatomic) NSInteger totalDistance;
@property (nonatomic) NSInteger busDistance;
@property (nonatomic) NSInteger bikeDistance;
@property (nonatomic) NSInteger walkingDistance;
@property (nonatomic) NSInteger transCount;

@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) AMapGeoPoint *departurePoint;
@property (nonatomic, strong) AMapGeoPoint *arrivalPoint;
@property (nonatomic) NSInteger strategy;

- (void)initSubViews;

@end
