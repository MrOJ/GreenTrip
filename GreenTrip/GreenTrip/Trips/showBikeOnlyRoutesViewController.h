//
//  showBikeOnlyRoutesViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"
#import "textBikeOnlyRoutesView.h"
#import "finishTripResultView.h"
#import "KLCPopup.h"
#import "YDConfigurationHelper.h"
#import "MBProgressHUD.h"

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface showBikeOnlyRoutesViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate,MBProgressHUDDelegate>
{
    AMapSearchAPI *search;
    MAMapView *myMapView;
    
    NSInteger indicatorTag;
    
    textBikeOnlyRoutesView *textBikeOnlyView;
    
    NSInteger flag;
    
    double ODDistance;
    
    AMapPOI *bikeStartPOI;
    AMapPOI *bikeEndPOI;
    
    NSString *startBikeName;
    NSString *endBikeName;
    
    NSMutableDictionary *allRoutesDictionary;     //存放所有线路
    
    AMapRoute *startWalkingRoute;    //起始步行路线
    AMapRoute *endWalkingRoute;      //终点步行的路线
    AMapRoute *bikeRoute;            //公共自行车行使的路线
    
    NSMutableArray *walkingPolylineArray;
    NSMutableArray *bikePolylineArray;
    NSMutableArray *busPolylineArray;
    
    NSMutableArray *pointAnnotationArray;

    NSMutableArray *wayIndexArray;
    
    NSInteger totalDistance;    //行程总路程
    NSInteger busDistance;      //公交车路程
    NSInteger walkingDistance;  //步行总距离
    NSInteger bikeDistance;     //自行车距离
    NSInteger transCount;       //换乘次数
    
    MAUserLocation *myUserLocation;
    
    UIActivityIndicatorView *activityIndicatorView;
    
    int isFinishTrip;
    
    MBProgressHUD *HUD;
}

@property(nonatomic, strong) AMapGeoPoint *startPoint;
@property(nonatomic, strong) AMapGeoPoint *endPoint;
@property(nonatomic, strong) NSString *startName;
@property(nonatomic, strong) NSString *endName;

@property (nonatomic, strong) UIButton *indicatorButton;
@property (nonatomic, strong) UIView *scalingView;
@property (strong, nonatomic) UIButton *increaseButton;
@property (strong, nonatomic) UIButton *decreaseButton;

@end
