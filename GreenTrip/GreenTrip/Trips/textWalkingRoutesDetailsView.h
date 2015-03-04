//
//  textWalkingRoutesDetailsView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/2.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ExtensibleTableView.h"

#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]

@interface textWalkingRoutesDetailsView : UIView<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGPoint beginPoint;
    CGPoint initPoint;
    BOOL isUp;
    
    UIImageView *currentImageView;
    
    UIImageView *arrowImageView;
    
    NSMutableArray *stepArray;
    NSMutableArray *originPonitArray;
}

@property (nonatomic) BOOL dragEnable;
@property (nonatomic,strong) AMapRoute *walkingRoute;

@property (nonatomic, strong) NSString *startName;                //起点名称
@property (nonatomic, strong) NSString *endName;                  //终点名称

- (void)buildingView;
- (NSString *)timeFormatted:(NSInteger)totalSeconds;

@end
