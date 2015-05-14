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

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface showBikeOnlyRoutesViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate>
{
    AMapSearchAPI *search;
    MAMapView *myMapView;
    
    NSInteger indicatorTag;
    
    textBikeOnlyRoutesView *textBikeOnlyView;
    
    NSInteger flag;
    
    double ODDistance;
    
    AMapPOI *targetStartPOI;
    AMapPOI *targetEndPOI;

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
