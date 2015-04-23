//
//  ARController.h
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) ((x) * 180.0/M_PI)

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@class ARCoordinate;
@class ARGeoCoordinate;

@interface ARController : NSObject<UIAccelerometerDelegate, CLLocationManagerDelegate, MAMapViewDelegate,AMapSearchDelegate>
{
    
    UIView *noticeView;
    BOOL isTheFirst;
    
    MAMapView *myMapView;
    
    UILabel *descLabel;
    
    AMapSearchAPI *search;
    
    NSMutableArray *oldCoordinates;
    
    UIImageView *arrowImageView;
    float angle;
    CLLocationDegrees latitudeOfTargetedPoint;
    CLLocationDegrees longitudeOfTargetedPoint;
    
    NSString *targetBusStop;
    AMapGeoPoint *geoPoint;

}

@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, retain) UIView *hudView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CMMotionManager *motionManager;


@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic) double range;

@property (nonatomic, retain) CLLocation *deviceLocation;
@property (nonatomic, retain) CLHeading *deviceHeading;

@property (nonatomic,retain) ARCoordinate *coordinate;

@property (nonatomic) double viewAngle;

@property (nonatomic, strong) NSMutableArray *coordinates;

@property (nonatomic, strong) NSMutableArray *busStopArray;



- (id)initWithViewController:(UIViewController *)viewController;
- (void)presentModalARControllerAnimated:(BOOL)animated;

- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;
- (void)removeCoordinate:(ARCoordinate *)coordiante animated:(BOOL)animated;

- (void)dismissModalARController:(BOOL)aninated;

@end
