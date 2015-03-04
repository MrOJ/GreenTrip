//
//  ARViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/5.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "ARViewController.h"
#import "ARController.h"
#import "ARGeoCoordinate.h"

#define kFilteringFactor                0.1
#define kEraseAccelerationThreshold        2.0

@interface ARViewController ()

@end

@implementation ARViewController

@synthesize arController, search,locationManager, deviceOrientation,busStopArray;

- (void)loadView {
    [MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    arController = [[ARController alloc] initWithViewController:self];
    
    arController.busStopArray = busStopArray;
    
    //self.navigationController.navigationBarHidden = NO;
    
    //[MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";
    //myMapView = [[MAMapView alloc] init];
    //myMapView.delegate = self;
    //myMapView.showsUserLocation = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.arController presentModalARControllerAnimated:NO];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [self.view addSubview:navigationBar];
    
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 50, 30)];
    [exitButton setTitle:@"返回" forState:UIControlStateNormal];
    [exitButton.titleLabel setTextColor:iosBlue];
    [exitButton  addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:exitButton];
    
    //------------------------------------
    //[self.navigationController setNavigationBarHidden:NO];
}

/*
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
 
    //取出当前位置的坐标
    NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];//固定的站点，难怪不会实时动态更新
    poiRequest.keywords = @"公交站";
    poiRequest.radius= 800;
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    //NSString *strPoi = @"";
    //self.arController.coordinates = [[NSMutableArray alloc] init];
    //NSLog(@"coordinates = %@",self.arController.coordinates);
    //[self.arController.coordinates removeAllObjects];
    
    for (AMapPOI *p in response.pois) {
        //strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        
        CLLocation		*tempLocation;
        
        //目标位置坐标
        tempLocation = [[CLLocation alloc] initWithLatitude:p.location.latitude
                                                  longitude:p.location.longitude];
        tempCoordinate = [[ARGeoCoordinate alloc] initWithCoordinate:tempLocation
                                                                name:p.name
                                                               place:p.address];
        
        [self.arController addCoordinate:tempCoordinate animated:NO];
        
    }
    
    //NSLog(@"%@",strPoi);
    
}
*/

- (IBAction)exit:(id)sender
{
    NSLog(@"exit");
    [self.arController dismissModalARController:NO];
    //[self.arController.rootViewController dismissViewControllerAnimated:NO completion:nil];
    //[self.arController.rootViewController.navigationController popToRootViewControllerAnimated:NO];
    
}

- (void)shakeEvent
{
    
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
