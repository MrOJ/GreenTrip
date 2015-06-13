//
//  showBikeOnlyRoutesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "showBikeOnlyRoutesViewController.h"
#import "YDConfigurationHelper.h"

@interface showBikeOnlyRoutesViewController ()

@end

@implementation showBikeOnlyRoutesViewController

@synthesize startPoint,endPoint,startName,endName;
@synthesize indicatorButton,increaseButton,scalingView,decreaseButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"绿色箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"结束行程" style:UIBarButtonItemStylePlain target:self action:@selector(finishTrip:)];
    self.navigationItem.rightBarButtonItem = registerButton;
    
    totalDistance = 0;
    busDistance   = 0;
    walkingDistance = 0;
    bikeDistance    = 0;
    transCount      = 0;
    
    isFinishTrip = 0;
    
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    allRoutesDictionary = [[NSMutableDictionary alloc] init];

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
    
    textBikeOnlyView  = [[textBikeOnlyRoutesView alloc] initWithFrame:CGRectMake(-1, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width + 2, self.view.bounds.size.height - 64 + 1 )];
    textBikeOnlyView.dragEnable = YES;
    textBikeOnlyView.startName = startName;
    textBikeOnlyView.endName = endName;
    [myMapView addSubview:textBikeOnlyView];
    
    [self callBicyclePOI:startPoint rasius:800];
    flag = 0;
    
    ODDistance = [self distanceBetweenOrderByA:startPoint B:endPoint];
    
    //正在加载指示视图
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 200, self.view.bounds.size.width - 100 * 2, 80)];
    activityIndicatorView.backgroundColor = [UIColor darkGrayColor];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)finishTrip:(id)sender
{
    NSLog(@"finish.");
    
    if (isFinishTrip == 0) {
        // 获取到达终点时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *Timestr = [formatter stringFromDate:[NSDate date]];
        
        CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:endPoint.latitude longitude:endPoint.longitude];
        double distance = [myUserLocation.location distanceFromLocation:destinationLocation];
        //NSLog(@"%f",distance);
        
        if (![[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] isEqualToString:@""]) {
            
            if (distance < 1000.0 && distance > 0.0) {
                
                finishTripResultView *finishView = [[finishTripResultView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 280) / 2, 40, 280, 290 + 90)];
                finishView.backgroundColor = [UIColor clearColor];
                finishView.totalDistance   = totalDistance;
                finishView.busDistance     = busDistance;
                finishView.walkingDistance = walkingDistance;
                finishView.bikeDistance    = bikeDistance;
                finishView.transCount      = transCount;
                
                finishView.departurePoint  = startPoint;
                finishView.arrivalTime     = Timestr;
                finishView.arrivalPoint    = endPoint;
                finishView.strategy        = 3;     //3表示自行车
                
                [finishView initSubViews];
                
                KLCPopup *popup = [KLCPopup popupWithContentView:finishView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
                [popup show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未到达终点，请即将到达终点后结束行程" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录后即可制定个性化行程" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        isFinishTrip = 1;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此次行程已经结束" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

# pragma search Delegate
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    NSLog(@"responne count =  %ld",(long)response.count);
    NSLog(@"%ld",(long)[self getSegmentsWithTarget:request.origin]);
    if ([self getSegmentsWithTarget:request.origin] == 0) {
        [allRoutesDictionary setObject:response.route forKey:@"startWalking"];
        startWalkingRoute = response.route;
        //textBikeOnlyView.allRoutesDictionary = allRoutesDictionary;
    } else if ([self getSegmentsWithTarget:request.origin] == 1) {
        [allRoutesDictionary setObject:response.route forKey:@"bike"];
        bikeRoute = response.route;
        
        [self drawAnnotationAndOverlay];
        
        textBikeOnlyView.allRoutesDictionary = allRoutesDictionary;
        textBikeOnlyView.startBikeStopName = startBikeName;
        textBikeOnlyView.endBikeStopName = endBikeName;
        [textBikeOnlyView buildingView];
        
        [activityIndicatorView stopAnimating];
        
    } else if ([self getSegmentsWithTarget:request.origin] == 2) {
        [allRoutesDictionary setObject:response.route forKey:@"endWalking"];
        endWalkingRoute = response.route;
    }
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if (response.pois.count > 0) {
        NSString *city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
        
        if (flag == 0) {
            //NSLog(@"start = %@", response.pois[0]);
            //flag = 1;
            //targetStartPOI = [[AMapPOI alloc] init];
            /*
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
            */
            //步行路线查找
            bikeStartPOI = response.pois[0];
            startBikeName = bikeStartPOI.name;
            //NSLog(@"start = %@",bikeStartPOI);

            [self callWalkingSearchWithStart:startPoint End:[AMapGeoPoint locationWithLatitude:bikeStartPOI.location.latitude longitude:bikeStartPOI.location.longitude] city:city];
            [self callBicyclePOI:endPoint rasius:800];
        } else {
            bikeEndPOI = response.pois[0];
            endBikeName = bikeEndPOI.name;
            //步行路线查找
            [self callWalkingSearchWithStart:[AMapGeoPoint locationWithLatitude:bikeEndPOI.location.latitude longitude:bikeEndPOI.location.longitude] End:endPoint city:city];
            
            //自行车路线查找
            [self callWalkingSearchWithStart:[AMapGeoPoint locationWithLatitude:bikeStartPOI.location.latitude longitude:bikeStartPOI.location.longitude] End:[AMapGeoPoint locationWithLatitude:bikeEndPOI.location.latitude longitude:bikeEndPOI.location.longitude] city:city];
        }
        
        flag = 1;
        
    } else {
        //NSLog(@"附近未找到站点!");
        [self showErrorWithMessage:@"附近未找到站点!"];
    }

}

# pragma draw on map
//绘制线路和标注的函数
- (void)drawAnnotationAndOverlay
{
    pointAnnotationArray = [[NSMutableArray alloc] init];
    
    walkingPolylineArray = [[NSMutableArray alloc] init];
    bikePolylineArray    = [[NSMutableArray alloc] init];
    busPolylineArray     = [[NSMutableArray alloc] init];
    wayIndexArray        = [[NSMutableArray alloc] init];
    
    //处理步行线路
    for (AMapPath *p in startWalkingRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [walkingPolylineArray addObject:polyline];
        }
        
        AMapGeoPoint *walkingPoint = startWalkingRoute.origin;
        MAPointAnnotation *walkingAnnotation = [[MAPointAnnotation alloc] init];
        walkingAnnotation.coordinate = CLLocationCoordinate2DMake(walkingPoint.latitude, walkingPoint.longitude);
        [pointAnnotationArray addObject:walkingAnnotation];
        [wayIndexArray addObject:@"2"];      // 2-步行
        
        totalDistance   += p.distance;
        walkingDistance += p.distance;
        
    }
    
    //处理步行线路
    for (AMapPath *p in endWalkingRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [walkingPolylineArray addObject:polyline];
        }
        
        AMapGeoPoint *walkingPoint = endWalkingRoute.origin;
        MAPointAnnotation *walkingAnnotation = [[MAPointAnnotation alloc] init];
        walkingAnnotation.coordinate = CLLocationCoordinate2DMake(walkingPoint.latitude, walkingPoint.longitude);
        [pointAnnotationArray addObject:walkingAnnotation];
        [wayIndexArray addObject:@"2"];      // 2-步行
        
        totalDistance   += p.distance;
        walkingDistance += p.distance;
        
    }
    
    //处理自行车线路
    for (AMapPath *p in bikeRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [bikePolylineArray addObject:polyline];
        }
        
        AMapGeoPoint *bikePoint = bikeRoute.origin;
        MAPointAnnotation *bikeAnnotation = [[MAPointAnnotation alloc] init];
        bikeAnnotation.coordinate = CLLocationCoordinate2DMake(bikePoint.latitude, bikePoint.longitude);
        [pointAnnotationArray addObject:bikeAnnotation];
        [wayIndexArray addObject:@"4"];      // 2-步行
        
        totalDistance   += p.distance;
        bikeDistance += p.distance;
        
    }
    
    //添加标注
    MAPointAnnotation *originAnnotation = [[MAPointAnnotation alloc] init];
    originAnnotation.coordinate = CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude);
    [pointAnnotationArray addObject:originAnnotation];
    [wayIndexArray addObject:@"0"];        //0-起点
    
    MAPointAnnotation *desAnnotation = [[MAPointAnnotation alloc] init];
    desAnnotation.coordinate = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);
    [pointAnnotationArray addObject:desAnnotation];
    [wayIndexArray addObject:@"1"];        //1-终点
    
    
    [myMapView addOverlays:walkingPolylineArray];
    [myMapView addOverlays:bikePolylineArray];
    [myMapView addOverlays:busPolylineArray];
    
    [myMapView addAnnotations:pointAnnotationArray];
    
    myMapView.visibleMapRect = [CommonUtility minMapRectForAnnotations:pointAnnotationArray];
    
}

//实现标注代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        NSString *wayReuslt = [self findWayInAnnotationArray:pointAnnotationArray targetAnnotation:annotation];
        //NSLog(@"%@",wayReuslt);
        if ([wayReuslt isEqualToString:@"0"]) {    //起点
            annotationView.canShowCallout= NO;
            annotationView.image = [UIImage imageNamed:@"38x60px-01"];
            return annotationView;
        } else if ([wayReuslt isEqualToString:@"1"]) {
            annotationView.canShowCallout= NO;            //终点
            annotationView.image = [UIImage imageNamed:@"38x60px-02"];
            return annotationView;
        } else  if ([wayReuslt isEqualToString:@"2"]){
            annotationView.canShowCallout= NO;            //步行
            annotationView.image = [UIImage imageNamed:@"行走转换22x22px"];
            return annotationView;
        } else  if ([wayReuslt isEqualToString:@"3"]){
            annotationView.canShowCallout= NO;            //公交车
            annotationView.image = [UIImage imageNamed:@"公交转换22x22px"];
            return annotationView;
        }  else  if ([wayReuslt isEqualToString:@"4"]){
            annotationView.canShowCallout= NO;            //公交车
            annotationView.image = [UIImage imageNamed:@"骑车转换22x22px"];
            return annotationView;
        }
    }
    return nil;
}

//实现路线代理
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        if ([self isInArray:walkingPolylineArray target:overlay]) {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = myColor;
            //polylineView.lineJoin = kCALineJoinRound;//连接类型
            //polylineView.lineCapType = kCALineCapRound;//端点类型
        } else if ([self isInArray:bikePolylineArray target:overlay]) {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor cyanColor];
            
        } else {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor orangeColor];
        }
        
        return polylineView;
    }
    return nil;
}

//位置更新回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        myUserLocation = userLocation;
        
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

- (void)callWalkingSearchWithStart:(AMapGeoPoint *)start End:(AMapGeoPoint *)end city:(NSString *)city
{
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviWalking;
    //naviRequest.requireExtension = YES;
    naviRequest.origin = start;
    naviRequest.destination = end;
    naviRequest.city = city;
    //发起路径搜索
    [search AMapNavigationSearch: naviRequest];
}

- (NSInteger)getSegmentsWithTarget:(AMapGeoPoint *)target
{
    
    if (target.latitude == startPoint.latitude && target.longitude == startPoint.longitude) {
        return 0;
    } else if (target.latitude == bikeStartPOI.location.latitude && target.longitude == bikeStartPOI.location.longitude){
        return 1;   //表示自行车
    } else {
        return 2;   //表示步行
    }
}


-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查找失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//路径字符串转换为曲线数组
- (MAPolyline *)polylineStrToGeoPoint:(NSString *)polylineStr
{
    NSArray *splitArray = [[NSArray alloc] init];
    splitArray = [polylineStr componentsSeparatedByString:@";"];
    CLLocationCoordinate2D polylineCoords[[splitArray count]];
    int i = 0;
    for (NSString *s in splitArray) {
        NSArray *tmpSplitArray = [[NSArray alloc] init];
        tmpSplitArray = [s componentsSeparatedByString:@","];
        float latitude = [tmpSplitArray[1] floatValue];
        float longtitude = [tmpSplitArray[0] floatValue];
        polylineCoords[i].latitude = latitude;
        polylineCoords[i].longitude = longtitude;
        i++;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:[splitArray count]];
    
    return polyline;
}

- (BOOL)isInArray:(NSArray *)array target:(MAPolyline *)target
{
    for (int i = 0; i < [array count]; i++) {
        if ([target isEqual:array[i]]) {
            return YES;
        }
    }
    return  NO;
}

- (NSString *)findWayInAnnotationArray:(NSMutableArray *)annotationArray targetAnnotation:(MAPointAnnotation *)annotation
{
    for (int i = 0; i < annotationArray.count; i++) {
        if ([annotation isEqual:[annotationArray objectAtIndex:i]]) {
            return [wayIndexArray objectAtIndex:i];
        }
    }
    return nil;
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
