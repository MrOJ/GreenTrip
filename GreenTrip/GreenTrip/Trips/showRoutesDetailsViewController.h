//
//  showRoutesDetailsViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/27.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"
#import "textRoutesDetailsScrollView.h"
#import "textWalkingRoutesDetailsView.h"
#import "finishTripResultView.h"
#import "KLCPopup.h"

@interface showRoutesDetailsViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    MAMapView *myMapView;
    AMapSearchAPI *search;
    
    NSMutableArray *pointAnnotationArray;
    NSMutableArray *walkingPolylineArray;
    NSMutableArray *busPolylineArray;
    
    MAPointAnnotation *departureAnnotation;
    MAPointAnnotation *destiAnnotation;
    
    MAPointAnnotation *walkingAnnotation;
    MAPointAnnotation *busAnnotation;
    
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
    
    textRoutesDetailsScrollView  *textDetailsScrollView;
    textWalkingRoutesDetailsView *textWRDView;
    
    NSMutableArray *wayIndexArray;
    
    NSInteger indicatorTag;
    
    NSInteger totalDistance;    //行程总路程
    NSInteger busDistance;      //公交车路程
    NSInteger walkingDistance;  //步行总距离
    NSInteger transCount;       //换乘次数
}

@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger wayFlag;
@property (nonatomic, strong) NSString *startName;
@property (nonatomic, strong) NSString *endName;
@property (nonatomic, strong) AMapRoute *allRoutes;

@property (nonatomic, strong) UIButton *indicatorButton;
@property (nonatomic, strong) UIView *scalingView;
@property (strong, nonatomic) UIButton *increaseButton;
@property (strong, nonatomic) UIButton *decreaseButton;

@property (nonatomic, strong)NSMutableArray *buslineArray;         //获取公交线路名称
@property (nonatomic, strong)NSMutableArray *totalDisArray;        //获取总距离
@property (nonatomic, strong)NSMutableArray *walkDisArray;         //获取步行距离
@property (nonatomic, strong)NSMutableArray *durationArray;        //获取时间

- (void)drawAnnotationAndOverlay:(NSInteger)pageIndex;
- (MAPolyline *)polylineStrToGeoPoint:(NSString *)polylineStr;
- (BOOL)isInArray:(NSArray *)array target:(MAPolyline *)target;


@end
