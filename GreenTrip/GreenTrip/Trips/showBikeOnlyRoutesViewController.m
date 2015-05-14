//
//  showBikeOnlyRoutesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "showBikeOnlyRoutesViewController.h"

@interface showBikeOnlyRoutesViewController ()

@end

@implementation showBikeOnlyRoutesViewController

@synthesize startPoint,endPoint,startName,endName;
@synthesize indicatorButton,increaseButton,scalingView,decreaseButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];

    myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height)];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    //myMapView.userTrackingMode = MAUserTrackingModeFollow;
    //myMapView.zoomLevel = 15;
    myMapView.showsCompass = YES;
    myMapView.showsScale = YES;
    [self.view addSubview:myMapView];
    
    indicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.view.bounds.size.height - 184 - 15, 35, 35)];
    indicatorButton.layer.shadowOffset = CGSizeMake(1, 1);
    indicatorButton.layer.shadowOpacity = 0.3f;
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140.png"] forState:UIControlStateNormal];
    [indicatorButton addTarget:self action:@selector(getIndicator:) forControlEvents:UIControlEventTouchUpInside];
    indicatorTag = 0;
    [myMapView addSubview:indicatorButton];
    
    scalingView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 15 - 39, self.view.bounds.size.height - 184 - 15 - 78 + 35, 35, 78)];
    scalingView.backgroundColor = [UIColor whiteColor];
    scalingView.layer.cornerRadius = 3.0f;
    
    increaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    [increaseButton setImage:[UIImage imageNamed:@"放大140x156"] forState:UIControlStateNormal];
    [increaseButton addTarget:self action:@selector(increaseScaling:) forControlEvents:UIControlEventTouchUpInside];
    [scalingView addSubview:increaseButton];
    decreaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 39, 39, 39)];
    [decreaseButton setImage:[UIImage imageNamed:@"缩小140x156"] forState:UIControlStateNormal];
    [decreaseButton addTarget:self action:@selector(decreaseScaling:) forControlEvents:UIControlEventTouchUpInside];
    [scalingView addSubview:decreaseButton];
    
    [myMapView addSubview:scalingView];
    
    textBikeOnlyView = [[textBikeOnlyRoutesView alloc] initWithFrame:CGRectMake(-1, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width + 2, self.view.bounds.size.height - 64 + 1 )];
    textBikeOnlyView.dragEnable = YES;
    //textBikeOnlyRoutesView.startName = startName;
    //textBikeOnlyRoutesView.endName = endName;
    [myMapView addSubview:textBikeOnlyView];
    
    [self callBicyclePOI:startPoint rasius:800];
    flag = 0;
    
    ODDistance = [self distanceBetweenOrderByA:startPoint B:endPoint];
}

# pragma button
- (void)getIndicator:(id)sender {
    //NSLog(@"%ld",(long)indicatorTag);
    if (indicatorTag == 0) {
        //必须先调用用户模式，否则indicatorbutton等会被初始化！！
        myMapView.userTrackingMode = MAUserTrackingModeFollow;
        indicatorButton.selected = YES;
        [indicatorButton setImage:[UIImage imageNamed:@"指南140x140选中"] forState:UIControlStateSelected];
        indicatorTag = 1;
        //mapView.zoomLevel = 15.0f;
        //mapView.showsCompass = NO;
    } else if (indicatorTag == 1) {
        myMapView.zoomLevel = 15.0f;
        myMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        indicatorButton.selected = NO;
        [indicatorButton setImage:[UIImage imageNamed:@"140x140px"] forState:UIControlStateNormal];
        indicatorTag = 2;
        //mapView.showsCompass = YES;
    } else if (indicatorTag == 2) {
        //myMapView.zoomLevel = 15.0f;
        myMapView.userTrackingMode = MAUserTrackingModeFollow;
        indicatorButton.selected = YES;
        [indicatorButton setImage:[UIImage imageNamed:@"指南140x140选中"] forState:UIControlStateSelected];
        indicatorTag = 1;
        //mapView.showsCompass = NO;
    }
    
    //indicatorButton.selected = YES;
    //NSLog(@"Hello!");
    
}

- (void)increaseScaling:(id)sender {
    float curZoomlevel = myMapView.zoomLevel;
    NSLog(@"%f",curZoomlevel);
    if (curZoomlevel < myMapView.maxZoomLevel && curZoomlevel >= 2.0) {
        [increaseButton setEnabled:YES];
        [decreaseButton setEnabled:YES];
        myMapView.zoomLevel = curZoomlevel + 1;
    } else {
        [increaseButton setEnabled:NO];
        //increaseButton.enabled = NO;
    }
}

- (void)decreaseScaling:(id)sender {
    
    float curZoomlevel = myMapView.zoomLevel;
    NSLog(@"%f",curZoomlevel);
    if (curZoomlevel <= myMapView.maxZoomLevel && curZoomlevel > 2.0) {
        [increaseButton setEnabled:YES];
        [decreaseButton setEnabled:YES];
        myMapView.zoomLevel = curZoomlevel - 1;
    } else {
        [decreaseButton setEnabled:NO];
    }
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"change!");
    myMapView.userTrackingMode = MAUserTrackingModeNone;
    indicatorButton.selected = NO;
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140"] forState:UIControlStateNormal];
    indicatorTag = 0;
    
}

# pragma search Delegate
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if (response.pois.count > 0) {
        if (flag == 0) {
            //NSLog(@"start = %@", response.pois[0]);
            //flag = 1;
            //targetStartPOI = [[AMapPOI alloc] init];
            double tempCos = 0.0;
            for (AMapPOI *p in response.pois) {
                //AMapGeoPoint *pioint = p.location;
                //NSLog(@"start = %f",[self getAngleWithTarget:p.location withFlag:0]);
                if (tempCos < [self getAngleWithTarget:p.location withFlag:0]) {
                    tempCos = [self getAngleWithTarget:p.location withFlag:0];
                    targetStartPOI = p;
                }
            }
            NSLog(@"start = %f",tempCos);
            NSLog(@"start = %@",targetStartPOI);
            [self callBicyclePOI:endPoint rasius:800];
        } else {
            //targetEndPOI = [[AMapPOI alloc] init];
            double tempCos = 0.0;
            for (AMapPOI *p in response.pois) {
                //NSLog(@"end = %@",p);
                //NSLog(@"end = %f",[self getAngleWithTarget:p.location withFlag:1]);
                if (tempCos < [self getAngleWithTarget:p.location withFlag:1]) {
                    tempCos = [self getAngleWithTarget:p.location withFlag:1];
                    targetEndPOI = p;
                }
                
            }
            NSLog(@"end = %f",tempCos);
            NSLog(@"end = %@",targetEndPOI);
            //NSLog(@"end = %@",response.pois[0]);
            //之后调用步行，在此操作，暂时放着
            
        }
        
        flag = 1;
        
    } else {
        //NSLog(@"附近未找到站点!");
        [self showErrorWithMessage:@"附近未找到站点!"];
    }

}


# pragma function
- (void)callBicyclePOI:(AMapGeoPoint *)point rasius:(NSInteger)r
{
    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    //起点搜寻r米范围内的自行车租赁点
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = point;//固定的站点，难怪不会实时动态更新
    poiRequest.keywords = @"自行车租赁点";
    poiRequest.radius= r;
    [search AMapPlaceSearch: poiRequest];
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查找失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//一直三个经纬度，求夹角
- (double)getAngleWithTarget:(AMapGeoPoint *)targetPoint withFlag:(NSInteger) f
{
    double toStart = [self distanceBetweenOrderByA:targetPoint B:startPoint];
    double toEnd = [self distanceBetweenOrderByA:targetPoint B:endPoint];
    
    if (f == 0) {
        double cosS = (toStart * toStart + ODDistance * ODDistance - toEnd * toEnd) / (2 * toStart * ODDistance);
        return cosS;
    } else {
        double cosE = (toEnd * toEnd + ODDistance * ODDistance - toStart * toStart) / (2 * toEnd * ODDistance);
        return cosE;
    }
    
}

//根据经纬度，求直线距离
- (double)distanceBetweenOrderByA:(AMapGeoPoint *)aPoint B:(AMapGeoPoint *)bPoint{
    double lat1 = aPoint.latitude;
    double lng1 = aPoint.longitude;
    double lat2 = bPoint.latitude;
    double lng2 = bPoint.longitude;
    
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //     return  distance*1000;
    
    //返回 m
    return   distance;
    
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
