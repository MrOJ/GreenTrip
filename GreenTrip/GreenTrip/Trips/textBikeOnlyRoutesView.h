//
//  textBikeOnlyRoutesView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
//#import "ExtensibleTableView.h"

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface textBikeOnlyRoutesView : UIView<UIGestureRecognizerDelegate>
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
    
    //ExtensibleTableView *listTableView;
}

@property (nonatomic) BOOL dragEnable;

- (void)buildingView;
- (NSString *)timeFormatted:(NSInteger)totalSeconds;

@end
