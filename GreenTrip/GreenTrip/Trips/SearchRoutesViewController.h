//
//  SearchRoutesViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "textFieldEditDetailsViewController.h"
#import "choosePreferViewController.h"
#import "showRoutesDetailsViewController.h"
#import "withBikeTransViewController.h"

@interface SearchRoutesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate,MAMapViewDelegate,UITextFieldDelegate>
{
    UIBarButtonItem *searchButton;
    UIView *busSearchRootView;
    UIView *busSearhBar;
    
    AMapSearchAPI *search;
    MAMapView *myMapView;
    
    UIActivityIndicatorView *activityIndicatorView;
    
    NSInteger wayFlag;   //判断当前用户选择了什么方式
    
    float userLatitude;
    float userLongtitude;
    
    AMapGeoPoint *startPoint;
    AMapGeoPoint *endPoint;
    
    NSString *getNameStr;
    NSString *getAddr;
    NSString *getLocation;
    NSString *getTextTag;
    
    NSInteger transCount;
    
    NSMutableArray *buslineArray;         //获取公交线路名称
    NSMutableArray *totalDisArray;        //获取总距离
    NSMutableArray *walkDisArray;         //获取步行距离
    NSMutableArray *durationArray;        //获取时间
    NSMutableArray *walkStepArray;        //步行路段数组，数组中存放 AMapStep 对象。
    NSMutableArray *busStopArray;         //途经公交站数组，数组中存放 AMapBusStop 对象。
    NSMutableArray *priceArray;           //票价,数据获取不到，暂时没加
    
    NSString *getPattern;                //获取偏好


    AMapRoute *getRoute;                //获得路线
    
}
//@property (strong, nonatomic) IBOutlet UISegmentedControl *chooseWay;
@property (strong, nonatomic) IBOutlet UIButton *busButton;
@property (strong, nonatomic) IBOutlet UIButton *walkButton;
@property (strong, nonatomic) IBOutlet UIButton *bikeButton;
@property (strong, nonatomic) IBOutlet UIButton *mixButton;

@property (strong, nonatomic) IBOutlet UITextField *startTextView;
@property (strong, nonatomic) IBOutlet UITextField *endTextView;
@property (strong, nonatomic) IBOutlet UITableView *ResultsTableView;

@property (strong, nonatomic) IBOutlet UIView *SearchView;
//@property (strong, nonatomic) IBOutlet UIView *walkSearchView;
//@property (strong, nonatomic) IBOutlet UIView *bikeSearchView;
//@property (strong, nonatomic) IBOutlet UIView *mixSearchView;

/*
- (void)showBusSearch;
- (void)showWalkSearch;
- (void)showBikeSearch;
- (void)showMixSearch;
*/

- (void)navigationBusSearchStartLacation:(AMapGeoPoint *)startLocation getLocation:(AMapGeoPoint *)endLocation chooseStategy:(NSInteger)strategy city:(NSString *)city;
- (void)navigationWalkingSearchStartLacation:(AMapGeoPoint *)startLocation getLocation:(AMapGeoPoint *)endLocation chooseStategy:(NSInteger)strategy city:(NSString *)city;
- (void)processBusResultData:(AMapNavigationSearchResponse *)response;
- (NSString *)timeFormatted:(NSInteger)totalSeconds;
- (NSString *)busNameTrans:(NSString *)originName;

@end
