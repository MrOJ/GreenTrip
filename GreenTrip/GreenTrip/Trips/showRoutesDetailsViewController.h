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

@interface showRoutesDetailsViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate,UIScrollViewDelegate>
{
    MAMapView *myMapView;
    AMapSearchAPI *search;
    
    NSMutableArray *pointAnnotationArray;
    NSMutableArray *walkingPolylineArray;
    NSMutableArray *busPolylineArray;
    
    MAPointAnnotation *departureAnnotation;
    MAPointAnnotation *destiAnnotation;
    
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
    
    textRoutesDetailsScrollView  *textDetailsScrollView;
    textWalkingRoutesDetailsView *textWRDView;
    
}

@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger wayFlag;
@property (nonatomic, strong) NSString *startName;
@property (nonatomic, strong) NSString *endName;
@property (nonatomic, strong) AMapRoute *allRoutes;

@property (nonatomic, strong)NSMutableArray *buslineArray;         //获取公交线路名称
@property (nonatomic, strong)NSMutableArray *totalDisArray;        //获取总距离
@property (nonatomic, strong)NSMutableArray *walkDisArray;         //获取步行距离
@property (nonatomic, strong)NSMutableArray *durationArray;        //获取时间

- (void)drawAnnotationAndOverlay:(NSInteger)pageIndex;
- (MAPolyline *)polylineStrToGeoPoint:(NSString *)polylineStr;
- (BOOL)isInArray:(NSArray *)array target:(MAPolyline *)target;


@end
