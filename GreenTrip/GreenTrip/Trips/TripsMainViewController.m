//
//  TripsMainViewController.m
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "TripsMainViewController.h"

@interface TripsMainViewController ()

@end

@implementation TripsMainViewController

@synthesize _mapView,mapView,titleV,startButton,indicatorButton,scalingView;
@synthesize increaseButton,decreaseButton;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //self.navigationItem.title = @"绿出行";
    self.navigationController.navigationBar.barTintColor = myColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
    // Do any additional setup after loading the view.
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";    //
    
    mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), CGRectGetHeight(_mapView.bounds))];
    mapView.delegate = self;
    mapView.layer.cornerRadius = 5;
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.zoomLevel = 15;
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    [_mapView addSubview:mapView];
    
    titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height)];
    //titleV.backgroundColor = myColor;
    [self.navigationItem.titleView addSubview:titleV];
    
    //startButton.layer.masksToBounds = YES;
    startButton.layer.shadowOffset = CGSizeMake(3, 3);
    startButton.layer.shadowOpacity = 0.3f;

    //indicatorButton.layer.masksToBounds = YES;
    indicatorButton.layer.shadowOffset = CGSizeMake(1, 1);
    indicatorButton.layer.shadowOpacity = 0.3f;
    //[indicatorButton seti]
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140选中.png"] forState:UIControlStateSelected];
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140.png"] forState:UIControlStateNormal];
    indicatorTag = 0;
    
    //scalingView.layer.masksToBounds = YES;
    scalingView.layer.shadowOffset = CGSizeMake(1, 1);
    scalingView.layer.shadowOpacity = 0.3f;
    scalingView.layer.cornerRadius = 3.0f;
    
    [mapView addSubview:indicatorButton];
    [mapView addSubview:startButton];
    [mapView addSubview:scalingView];
    
    //[increaseButton setEnabled:NO];
    
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    //tapGesture.numberOfTapsRequired = 1;
    //tapGesture.delegate = self;
    [mapView addGestureRecognizer:tapGesture];
}

- (IBAction)getIndicator:(id)sender {
    
    if (indicatorTag == 0) {
        indicatorButton.selected = YES;
        indicatorTag = 1;
        mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        mapView.zoomLevel = 15.0f;
        mapView.showsCompass = YES;
    } else if (indicatorTag == 1) {
        indicatorButton.selected = NO;
        indicatorTag = 0;
        mapView.userTrackingMode = MAUserTrackingModeNone;
        mapView.showsCompass = NO;
    }
    
    //indicatorButton.selected = YES;
    //NSLog(@"Hello!");
    
}

- (IBAction)increaseScaling:(id)sender {
    float curZoomlevel = mapView.zoomLevel;
    NSLog(@"%f",curZoomlevel);
    if (curZoomlevel < mapView.maxZoomLevel && curZoomlevel >= 2.0) {
        [increaseButton setEnabled:YES];
        [decreaseButton setEnabled:YES];
        mapView.zoomLevel = curZoomlevel + 1;
    } else {
        [increaseButton setEnabled:NO];
        //increaseButton.enabled = NO;
    }
    //NSLog(@"zoomlevel = %f",mapView.zoomLevel);
    //NSLog(@"maxzoomlevel = %f",mapView.maxZoomLevel);
}

- (IBAction)decreaseScaling:(id)sender {
    //NSLog(@"zoomlevel = %f",mapView.zoomLevel);
    //NSLog(@"minzoomlevel = %f",mapView.minZoomLevel);
    float curZoomlevel = mapView.zoomLevel;
    NSLog(@"%f",curZoomlevel);
    if (curZoomlevel <= mapView.maxZoomLevel && curZoomlevel > 2.0) {
        [increaseButton setEnabled:YES];
        [decreaseButton setEnabled:YES];
        mapView.zoomLevel = curZoomlevel - 1;
    } else {
        [decreaseButton setEnabled:NO];
    }
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return reSizeImage;
    
}

//点击地图以后调用
- (void)singleTap:(UIGestureRecognizer *)recognizer
{
    NSLog(@"Tap!");
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (indicatorButton.tag == 1) {
        NSLog(@"Tap");
    } else {
        
    }
}

/*
//位置更新回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
    }
}
*/
 
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        //pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        //pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        //pre.lineWidth = 3;
        //pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
