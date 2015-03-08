//
//  textWithBikeTransDetailsView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/2.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ExtensibleTableView.h"

#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]
#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface textWithBikeTransDetailsView : UIView <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGPoint beginPoint;
    CGPoint initPoint;
    BOOL isUp;
    
    UIImageView *currentImageView;
    
    UIImageView *arrowImageView;
    
    NSMutableArray *stepArray;
    NSMutableArray *originPonitArray;
    
    NSInteger totalDistance;
    NSInteger totalWalkingDistance;
    NSInteger totalBikeDistance;
    NSInteger totalDuration;
    
    NSMutableArray *stopArray;
    NSMutableArray *strategyArray;
    NSMutableArray *strDetailsArray;
    NSMutableArray *detailWaysArray;   //记录具体的行走指示或者途径公交站点，点击后显示详细信息
    NSMutableArray *flagArray;         //用于标记是步行0还是公交1还是终点2
    
    NSArray *bikeSteps;
    NSString *bikeStr;
    
    ExtensibleTableView *listTableView;
}

@property (nonatomic) BOOL dragEnable;
@property (nonatomic) int flag;                                   //用于记录是从起点开始还是从终点开始
@property (nonatomic, strong) AMapRoute *walkingRoute;
@property (nonatomic, strong) AMapRoute *bikeRoute;
@property (nonatomic, strong) AMapRoute *busRoute;

@property (nonatomic, strong) NSString *startName;                //起点名称
@property (nonatomic, strong) NSString *endName;                  //终点名称
@property (nonatomic, strong) NSString *busName;

@property (nonatomic, strong) NSString *startBikeStopName;
@property (nonatomic, strong) NSString *endBikeStopName;

@property (nonatomic, strong) NSMutableDictionary *allRoutesDictionary;                //存放总线路

- (void)buildingView;
- (NSString *)timeFormatted:(NSInteger)totalSeconds;

@end
