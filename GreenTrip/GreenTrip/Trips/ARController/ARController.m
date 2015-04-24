//
//  ARController.m
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import "ARController.h"
#import "ARCoordinate.h"
#import "ARGeoCoordinate.h"
#import "ARAnnotation.h"

#import <mach/mach_time.h>

@interface ARController (Private)

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

- (void)updateCurrentLocation:(CLLocation *)newLocation;
- (void)updateLocations;
- (void)updateCurrentCoordinate;
- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate;
- (double)deltaAzimuthForCoordinate:(ARCoordinate *)coordinate;
- (CGPoint)pointForCoordinate:(ARCoordinate *)coordinate;
- (BOOL)isNorthForCoordinate:(ARCoordinate *)coordinate;
@end

@implementation ARController

@synthesize rootViewController = _rootViewController;
@synthesize pickerController = _pickerController;
@synthesize hudView = _hudView;
@synthesize locationManager = _locationManager;
@synthesize motionManager = _motionManager;

@synthesize deviceOrientation = _deviceOrientation;
@synthesize range = _range;

@synthesize deviceHeading = _deviceHeading;
@synthesize deviceLocation = _deviceLocation;

@synthesize coordinate = _coordinate;

@synthesize viewAngle = _viewAngle;

@synthesize coordinates = _coordinates;

@synthesize busStopArray,alert;

- (id)initWithViewController:(UIViewController *)viewController {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将设备竖屏摆放" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    self.rootViewController = viewController;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    self.rootViewController.view = self.hudView;
    self.rootViewController.navigationController.navigationBarHidden = NO;
    
    self.pickerController = [[UIImagePickerController alloc] init];
	self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.65,1.65);
    self.pickerController.cameraViewTransform = cameraTransform;
    //CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, 100.0f);
    //transform = CGAffineTransformScale(transform, 1.2f, 1.2f);
    //self.pickerController.cameraViewTransform = transform;
    self.pickerController.view.frame = CGRectMake(0, 00, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	self.pickerController.showsCameraControls = NO;
    self.pickerController.navigationBar.hidden = NO;
	self.pickerController.cameraOverlayView = _hudView;
    
    noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    //noticeView.layer.cornerRadius = 5.0;
    //noticeView.layer.masksToBounds = YES;
    noticeView.layer.shadowColor = [UIColor grayColor].CGColor;
    noticeView.layer.shadowOffset = CGSizeMake(1, 1);
    noticeView.layer.shadowOpacity = 0.3;
    //设置背景透明度
    [noticeView setBackgroundColor:[UIColor whiteColor]];
    
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, [UIScreen mainScreen].bounds.size.width, 20)];
    descLabel.text = @"正在查找目标站点...";
    [descLabel setTextColor:[UIColor blackColor]];
    [noticeView addSubview:descLabel];
    
    [_hudView addSubview:noticeView];
    
    myMapView = [[MAMapView alloc] init];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    myMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    //设置初始值
    _coordinates = [[NSMutableArray alloc] init];
    oldCoordinates = [[NSMutableArray alloc] init];
    
    _range = _hudView.bounds.size.width / 12; // new
    _deviceLocation = [[CLLocation alloc] initWithLatitude:32.325736 longitude:120.017801];	 // new
    
    _coordinate = [[ARCoordinate alloc] initWithRadialDistance:1.0 inclination:0 azimuth:0];
    
    isTheFirst = TRUE;
    
    //添加指南针
    
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 50) / 2, [UIScreen mainScreen].bounds.size.height - 150, 50, 50)];
    arrowImageView.image = [UIImage imageNamed:@"1箭头154x152.png"];
    arrowImageView.hidden = YES;
    [_hudView addSubview:arrowImageView];
    
    return self;
}

- (void)presentModalARControllerAnimated:(BOOL)animated {
    //[self.rootViewController presentModalViewController:[self pickerController] animated:animated];
    [self.rootViewController presentViewController:[self pickerController] animated:animated completion:nil];
    //[self.rootViewController.view addSubview:self.pickerController.view];
    _hudView.frame = _pickerController.view.bounds;
}

- (void)dismissModalARController:(BOOL)aninated {
    //退出相机pickController
    [self.rootViewController dismissViewControllerAnimated:NO completion:nil];
    
    //退出这个视图
    [self.rootViewController.navigationController popViewControllerAnimated:NO];
    
    myMapView.showsUserLocation = NO;   //关闭定位
    
    
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIApplication *app = [UIApplication sharedApplication];
    
    //变换屏幕以使旋转不会正面朝上或朝下（忽略了未知的方向）
    if ( orientation != UIDeviceOrientationUnknown &&
        orientation !=  UIDeviceOrientationFaceUp &&
        orientation != UIDeviceOrientationFaceDown) {
		
		CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadians(0));
		CGRect bounds = [[UIScreen mainScreen] bounds];
		[app setStatusBarHidden:YES];
		[app setStatusBarOrientation:UIInterfaceOrientationPortrait animated: NO];
		
		if (orientation == UIDeviceOrientationLandscapeLeft) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadians(90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
			[app setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated: NO];
            
		} else if (orientation == UIDeviceOrientationLandscapeRight) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadians(-90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
			[app setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated: NO];
			
		} else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
			transform = CGAffineTransformMakeRotation(degreesToRadians(180));
			[app setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated: NO];
            
		}
		_hudView.transform = transform;           //对HUD施加变换
		_hudView.bounds = bounds;
		_range = _hudView.bounds.size.width / 12; //设置屏幕范围
        
	}
	_deviceOrientation = orientation;
    
    //强制竖屏显示
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        [_hudView setHidden:YES];
        [alert show];
    } else {
        [_hudView setHidden:NO];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

/*
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}
*/

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        //[_coordinates removeAllObjects];
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceAround;
        poiRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];//固定的站点，难怪不会实时动态更新
        poiRequest.keywords = @"公交站";
        poiRequest.radius= 1000;
        [search AMapPlaceSearch: poiRequest];
        
        angle = [self calculateAngle:userLocation.location];    //获取角度
        
        [self updateCurrentLocation:userLocation.location];
    } else {
        if (userLocation.heading.headingAccuracy > 0) {
            _deviceHeading = userLocation.heading;
            [self updateCurrentCoordinate];    //获得实时的方位角信息
            
            //箭头朝向设置
            //NSLog(@"heading = %@",userLocation.heading);
            float direction = userLocation.heading.magneticHeading;
            
            if (direction > 180) {
                direction = 360 - direction;
            } else {
                direction = 0 - direction;
            }
            
            // Rotate the arrow image
            if (arrowImageView)
            {
                [UIView animateWithDuration:3.0f animations:^{
                    arrowImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(direction) + angle);
                }];
            }
        }
    }

}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [_coordinates removeAllObjects];
    //NSLog(@"removed _coordinates")
    
    for (AMapPOI *p in response.pois) {
        //strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        
        CLLocation	*tempLocation = [[CLLocation alloc] initWithLatitude:p.location.latitude
                                                  longitude:p.location.longitude];
        
        //调试了一整天的bug，就是因为这里的初始化出现了问题
        /*
        ARGeoCoordinate *tempCoordinate = [[ARGeoCoordinate alloc] initWithCoordinate:tempLocation
                                                                name:p.name
                                                               place:p.address];
        */
        
        ARGeoCoordinate *test = [[ARGeoCoordinate alloc] initWithCoordinateAndOrigin:tempLocation name:p.name place:p.address origin:_deviceLocation];
        
        //[self addCoordinate:tempCoordinate animated:NO];
        [self addCoordinate:test animated:NO];
    }

    
    geoPoint = [self findBusStop:busStopArray inArray:_coordinates];
    NSLog(@"geoPoint = %@",geoPoint);
    // Set the coordinates of the location to be used for calculating the angle
    
    if (geoPoint != nil) {
        //arrowImageView.hidden = NO;
        latitudeOfTargetedPoint = geoPoint.latitude;
        longitudeOfTargetedPoint = geoPoint.longitude;
    } else {
        descLabel.text = @"附近未找到目标站点";
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    //[self.locationManager stopUpdatingLocation];
    NSLog(@"error: %@",error);
}
//-----------------------

- (void)updateCurrentLocation:(CLLocation *)newLocation{
    self.deviceLocation = newLocation;
    arrowImageView.hidden = NO;
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    CLLocationDistance distance = [self.deviceLocation distanceFromLocation:destination];
    
    NSString *str = [NSString stringWithFormat:@"目标站点:%@站 | 约%.1f米",targetBusStop,distance];
    
    if (targetBusStop != nil) {
        descLabel.text = str;
    } else {
        arrowImageView.hidden = YES;
    }
}

- (void)updateCurrentCoordinate {
	
	double adjustment = 0;
	if (_deviceOrientation == UIDeviceOrientationLandscapeLeft)
		adjustment = degreesToRadians(270);
	else if (_deviceOrientation == UIDeviceOrientationLandscapeRight)
		adjustment = degreesToRadians(90);
	else if (_deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
		adjustment = degreesToRadians(180);
    
	_coordinate.azimuth = degreesToRadians(_deviceHeading.magneticHeading) - adjustment;  //设备朝向的方位角
    
	[self updateLocations];
}

- (void)updateLocations{
	if ( !_coordinates || [_coordinates count] == 0 ) return;
    
    for (UIView *view in [_hudView subviews]) {
        if ([view isKindOfClass:[ARAnnotation class]]) {
            [view removeFromSuperview];
        }
    }
    
    int totalDisplayed	= 0;
    
	for (ARCoordinate *item in _coordinates) {
		//NSLog(@"looking at coordinate");
        
		UIView *viewToDraw = item.annotation;

		if ([self viewportContainsCoordinate:item]) {   //这里出现了问题！！！！！
            //NSLog(@"found point in viewport");
			CGPoint point = [self pointForCoordinate:item];
            
            //NSLog(@"point = %f,%f",point.x,point.y);
			float width	 = viewToDraw.bounds.size.width;
			float height = viewToDraw.bounds.size.height;
    
			viewToDraw.frame = CGRectMake(point.x, point.y  - (height / 2.0) - 150 + totalDisplayed * 55, width, height);
            
            
			if ( !([viewToDraw superview]) ) {
				[_hudView addSubview:viewToDraw];
				[_hudView sendSubviewToBack:viewToDraw];
			}
			totalDisplayed++;
            
		} else {
			[viewToDraw removeFromSuperview];
            
            //NSLog(@"remove the %@",viewToDraw);
            /*
            description.text = @"";
            //description.backgroundColor = [UIColor clearColor];
            [description setTextColor:[UIColor blackColor]];
            description.textAlignment = NSTextAlignmentCenter;
            [description sizeToFit];
            [noticeView addSubview:description];
            */
		}
	}
    //[_coordinates removeAllObjects];
}

- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
    //更新了一个新的ARAnnotation实例以用于坐标
    ARAnnotation *annotation = [[ARAnnotation alloc] initWithCoordinate:coordinate];
    coordinate.annotation = annotation;
    
    [_coordinates addObject:coordinate];
    
}

- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
	[_coordinates removeObject:coordinate];
}

- (BOOL)isInArray:(NSMutableArray *)array theTarget:(ARCoordinate *)target
{
    for (ARCoordinate *c in array) {
        if ([c.name isEqualToString:target.name]) {
            return YES;
        }
    }
    
    return NO;
}

//检测定义的范围（在屏幕上能够看到什么）并验证传入的坐标是否在指定的范围内。它可以忽视可视以外的坐标
- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate {
    
	double deltaAzimuth = [self deltaAzimuthForCoordinate:coordinate];
	BOOL result	= NO;
	if (deltaAzimuth <= degreesToRadians(_range)) {
    
		result = YES;
	}
	
	return result;
}

//计算位置的方位角与传入坐标的方位角之间的差值。
- (double)deltaAzimuthForCoordinate:(ARCoordinate *)coordinate {
    
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	  = coordinate.azimuth;
    
	double deltaAzimith = ABS( pointAzimuth - currentAzimuth);
	
	if (currentAzimuth < degreesToRadians(_range) &&
		pointAzimuth > degreesToRadians(360-_range)) {
		deltaAzimith	= (currentAzimuth + ((M_PI * 2.0) - pointAzimuth));
	} else if (pointAzimuth < degreesToRadians(_range) &&
			   currentAzimuth > degreesToRadians(360-_range)) {
		deltaAzimith	= (pointAzimuth + ((M_PI * 2.0) - currentAzimuth));
	}
	return deltaAzimith;
}

//遵循检查两个坐标的方位角的增量差值时使用的模式
-(BOOL)isNorthForCoordinate:(ARCoordinate *)coordinate {
	BOOL isBetweenNorth = NO;
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	= coordinate.azimuth;
    
	if ( currentAzimuth < degreesToRadians(_range) &&
        pointAzimuth > degreesToRadians(360-_range) ) {
		isBetweenNorth = YES;
	} else if ( pointAzimuth < degreesToRadians(_range) &&
               currentAzimuth > degreesToRadians(360-_range)) {
		isBetweenNorth = YES;
	}
	return isBetweenNorth;
}

//得到坐标差是否在方位角值的范围内以及这个坐标点是否在我们和北极方向之间
- (CGPoint)pointForCoordinate:(ARCoordinate *)coordinate {
    
	CGPoint point;
	CGRect viewBounds = _hudView.bounds;
	
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	= coordinate.azimuth;
	double pointInclination	= coordinate.inclination;
    
	double deltaAzimuth = [self deltaAzimuthForCoordinate:coordinate];
	BOOL isBetweenNorth	= [self isNorthForCoordinate:coordinate];
        
	if ((pointAzimuth > currentAzimuth && !isBetweenNorth) ||
		(currentAzimuth > degreesToRadians(360-_range) &&
		 pointAzimuth < degreesToRadians(_range))) {
			
            // Right side of Azimuth
            point.x = (viewBounds.size.width / 2) + ((deltaAzimuth / degreesToRadians(1)) * 12);
        } else {
			
            // Left side of Azimuth
            point.x = (viewBounds.size.width / 2) - ((deltaAzimuth / degreesToRadians(1)) * 12);
        }
	point.y = (viewBounds.size.height / 2)
    + (radiansToDegrees(M_PI_2 + _viewAngle)  * 2.0)
    + ((pointInclination / degreesToRadians(1)) * 12);
	
	return point;
}

//名称处理函数(去掉括号）
- (NSString *)busNameTrans:(NSString *)originName
{
    NSRange subRange = [originName rangeOfString:@"("];
    if (subRange.length == 0 && subRange.location == 0) {
        return originName;
    } else {
        return [originName substringToIndex:subRange.location];
    }
}

//查找目标公交站点函数
- (AMapGeoPoint *)findBusStop:(NSMutableArray *)getArray inArray:(NSMutableArray *)coodinates
{
    for (AMapBusStop *b in getArray) {
        for (ARCoordinate *ac in coodinates) {
            if ([b.name isEqualToString:[self busNameTrans:ac.name]]) {
                targetBusStop = b.name;
                return b.location;
            }
        }
    }
    
    return nil;
}

// Caculate the angle between the north and the direction to observed geo-location
-(float)calculateAngle:(CLLocation *)userlocation
{
    float userLocationLatitude = degreesToRadians(userlocation.coordinate.latitude);
    float userLocationLongitude = degreesToRadians(userlocation.coordinate.longitude);
    
    float targetedPointLatitude = degreesToRadians(latitudeOfTargetedPoint);
    float targetedPointLongitude = degreesToRadians(longitudeOfTargetedPoint);
    
    float longitudeDifference = targetedPointLongitude - userLocationLongitude;
    
    float y = sin(longitudeDifference) * cos(targetedPointLatitude);
    float x = cos(userLocationLatitude) * sin(targetedPointLatitude) - sin(userLocationLatitude) * cos(targetedPointLatitude) * cos(longitudeDifference);
    float radiansValue = atan2(y, x);
    if(radiansValue < 0.0)
    {
        radiansValue += 2 * M_PI;
    }
    
    return radiansValue;
}

@end
