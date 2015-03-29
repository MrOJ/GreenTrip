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

@synthesize _mapView,mapView,titleV,startButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
    // Do any additional setup after loading the view.

    [MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";    //
    
    mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), CGRectGetHeight(_mapView.bounds))];
    mapView.delegate = self;
    mapView.layer.cornerRadius = 5;
    mapView.showsUserLocation = YES;
    //mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.zoomLevel = 15;
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    [_mapView addSubview:mapView];
    
    titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height)];
    //titleV.backgroundColor = myColor;
    [self.navigationItem.titleView addSubview:titleV];
    
    startButton.layer.shadowOffset = CGSizeMake(3, 3);
    startButton.layer.shadowOpacity = 0.3f;

    /*
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1出发未激活130x80@4x.png"] highlightedImage:[UIImage imageNamed:@"1出发130x80@4x.png"]];
    img.frame = CGRectMake(0, 0, 32, 20);
    img.contentMode = UIViewContentModeScaleToFill;
    */
    
    //UIImage *image = [UIImage imageNamed:@"tabBar1"];
    
    //UIImage *newImg = [self reSizeImage:image toSize:CGSizeMake(32, 20)];
    
    //self.BarItem.image = image;
    //self.tabBarController.tabBarItem.image = image;
    //[self.tabBarController.tabBar insertSubview:img atIndex:1];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return reSizeImage;
    
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
