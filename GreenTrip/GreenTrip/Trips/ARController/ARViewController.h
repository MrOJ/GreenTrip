//
//  ARViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/5.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <CoreMotion/CoreMotion.h>
#import "ARController.h"

#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]

@class ARController;

@interface ARViewController : UIViewController<CLLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>
{
    UIAccelerationValue myAccelerometer[3];
    
    BOOL _canShake;
    
    BOOL isTheFirst;
    ARGeoCoordinate *tempCoordinate;
    
    MAMapView *myMapView;
    
}

@property (nonatomic,strong) ARController *arController;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, strong) MAMapView *mapView;

@property(nonatomic, strong)CMMotionManager *motionManager;
@property(nonatomic, strong)NSOperationQueue *queue;

@property (nonatomic) UIDeviceOrientation deviceOrientation;

@property (nonatomic, strong) NSMutableArray *busStopArray;

- (void)shakeEvent;

@end
