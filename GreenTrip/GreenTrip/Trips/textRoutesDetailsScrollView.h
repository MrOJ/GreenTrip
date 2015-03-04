//
//  textRoutesDetailsScrollView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/29.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ExtensibleTableView.h"
#import "CommonUtility.h"
#import "ARViewController.h"

#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]

@interface textRoutesDetailsScrollView : UIScrollView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CGPoint beginPoint;
    CGPoint initPoint;
    BOOL isUp;
    
    //UIImageView *arrowImageView;
    //UILabel *busNameLabel;
    //UILabel *detailsLabel;
    UIImageView *currentImageView;
    
    //UIView *briefView;
    
    NSMutableArray *arrowImageViewArray;
    NSMutableArray *busNameLabelArray;
    NSMutableArray *detailsLabelArray;
    NSMutableArray *exTableViewArray;
    
    NSMutableArray *stopArray;
    NSMutableArray *strategyArray;
    NSMutableArray *strDetailsArray;
    NSMutableArray *flagArray;         //用于标记是步行0还是公交1还是终点2
    
    NSMutableArray *detailWaysArray;   //记录具体的行走指示或者途径公交站点，点击后显示详细信息
    
    NSMutableArray *busStopArray;      //存放站点数据，而不是数组，stopArray用于存放字符串
    
    //UIImageView *megeImg;              //箭头图片
    //ExtensibleTableView *exTableView;
}

@property (nonatomic) BOOL dragEnable;

@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) NSString *startName;                //起点名称
@property (nonatomic, strong) NSString *endName;                  //终点名称
@property (nonatomic, strong) AMapRoute *allRoutes;

@property (nonatomic, strong)NSMutableArray *buslineArray;         //获取公交线路名称
@property (nonatomic, strong)NSMutableArray *totalDisArray;        //获取总距离
@property (nonatomic, strong)NSMutableArray *walkDisArray;         //获取步行距离
@property (nonatomic, strong)NSMutableArray *durationArray;        //获取时间

- (void)showOnTheView:(NSInteger)i;
- (void)buildingView;
- (NSString *)getBusDirection:(NSString *)busName;
- (NSString *)busNameTrans:(NSString *)originName;
@end
