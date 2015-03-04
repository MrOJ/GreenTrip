//
//  withBikeTransViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/26.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"
#import "textWithBikeTransDetailsView.h"

@interface withBikeTransViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate>
{
    AMapSearchAPI *search;
    MAMapView *myMapView;
    
    NSInteger originTotalDis;
    
    int flag;
    int flag2;
    int flag3;
    
    //NSArray *bicyclePOIArray;
    NSMutableArray *bicyclePOIArray;
    
    BOOL isGetOriginDis;
    BOOL isFind;
    BOOL isBreak;
    
    NSMutableArray *findFromOriginArray;
    NSMutableArray *findFromDesArray;
    
    NSMutableArray *walkingPolylineArray;
    NSMutableArray *bikePolylineArray;
    NSMutableArray *busPolylineArray;
    
    NSMutableArray *pointAnnotationArray;
    
    NSInteger POICount;
    NSInteger poiNum;
    NSInteger POIIndex;
    
    AMapPOI *bicycleStationPOI;
    
    AMapGeoPoint *bikeStartPoint;
    
    AMapRoute *walkingRoute;      //步行找公共自行车的路线
    AMapRoute *bikeRoute;         //公共自行车行使的路线
    AMapRoute *busRoute;          //公交车路线
    
    textWithBikeTransDetailsView *textWithBikeTransDV;
    
    NSMutableDictionary *allRoutesDictionary;     //存放所有线路
    NSString *busName;
}

@property(nonatomic, strong) AMapGeoPoint *startPoint;
@property(nonatomic, strong) AMapGeoPoint *endPoint;

@property(nonatomic, strong) AMapPOI *bicyclePOI;

@end
