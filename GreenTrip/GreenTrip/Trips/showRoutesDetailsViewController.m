//
//  showRoutesDetailsViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/27.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "showRoutesDetailsViewController.h"

#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]
#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface showRoutesDetailsViewController ()

@end

@implementation showRoutesDetailsViewController

@synthesize index,allRoutes,buslineArray,totalDisArray,walkDisArray,durationArray,startName,endName,wayFlag;
@synthesize indicatorButton,scalingView,increaseButton,decreaseButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //NSLog(@"hello@@");
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStylePlain target:self action:@selector(finishTrip:)];
    //[registerButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = registerButton;
    
    NSString *myKey = @"f57ba48c60c524724d3beff7f7063af9";
    [MAMapServices sharedServices].apiKey = myKey;
    search = [[AMapSearchAPI alloc] initWithSearchKey:myKey Delegate:self];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
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
    
    
    
    //不知为何真机测试数据显示刷要两次，难道是BUG??
    [self drawAnnotationAndOverlay:index];
    [self drawAnnotationAndOverlay:index];
    
    if (wayFlag == 1) {
        self.navigationItem.title = @"公交路线";
        textDetailsScrollView = [[textRoutesDetailsScrollView alloc] initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width, self.view.bounds.size.height - 64 + 1)];
        
        textDetailsScrollView.contentSize = CGSizeMake((myMapView.bounds.size.width) * allRoutes.transits.count, 1);
        textDetailsScrollView.dragEnable = YES;
        
        textDetailsScrollView.pagingEnabled = YES; //是否翻页
        textDetailsScrollView.backgroundColor = [UIColor whiteColor];
        textDetailsScrollView.showsHorizontalScrollIndicator = NO;
        textDetailsScrollView.showsVerticalScrollIndicator = NO;
        textDetailsScrollView.delegate = self;
        
        [myMapView addSubview:textDetailsScrollView];
        
        textDetailsScrollView.index = index;
        textDetailsScrollView.startName = startName;
        textDetailsScrollView.endName = endName;
        textDetailsScrollView.allRoutes = allRoutes;
        textDetailsScrollView.buslineArray = buslineArray;
        textDetailsScrollView.totalDisArray = totalDisArray;
        textDetailsScrollView.walkDisArray = walkDisArray;
        textDetailsScrollView.durationArray = durationArray;
        
        textDetailsScrollView.currentIndex = index;
        
        [textDetailsScrollView buildingView];
        [textDetailsScrollView showOnTheView:index];
        [self loadScrollView:textDetailsScrollView withPage:index];
    } else if (wayFlag == 2) {                //步行线路
        self.navigationItem.title = @"步行路线";
        textWRDView = [[textWalkingRoutesDetailsView alloc] initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width, self.view.bounds.size.height - 64 + 1)];
        textWRDView.dragEnable = YES;
        textWRDView.walkingRoute = allRoutes;
        textWRDView.startName = startName;
        textWRDView.endName = endName;
        textWRDView.wayFlag = wayFlag;
        
        [myMapView addSubview:textWRDView];
        [textWRDView buildingView];
                                                                                     
    } else if (wayFlag == 3) {                //自行车线路
        self.navigationItem.title = @"自行车路线";
        textWRDView = [[textWalkingRoutesDetailsView alloc] initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width, self.view.bounds.size.height - 64 + 1)];
        textWRDView.dragEnable = YES;
        textWRDView.wayFlag = wayFlag;
        textWRDView.walkingRoute = allRoutes;
        textWRDView.startName = startName;
        textWRDView.endName = endName;
        
        [myMapView addSubview:textWRDView];
        [textWRDView buildingView];
    }
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 10, myMapView.bounds.size.width, 10)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = allRoutes.transits.count;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPage = index;
    pageControl.currentPageIndicatorTintColor = myColor;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    //[self createPages];
    
    [myMapView addSubview:pageControl];
    
    //[self drawAnnotationAndOverlay:index];
    //添加点击手势
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    */
    
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

//点击地图以后调用
- (void)singleTap:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"Tap!");
    myMapView.userTrackingMode = MAUserTrackingModeNone;
    indicatorButton.selected = NO;
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140"] forState:UIControlStateNormal];
    indicatorTag = 0;
    
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
    finishTripResultView *finishView = [[finishTripResultView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 280) / 2, 40, 280, 290 + 90)];
    finishView.backgroundColor = [UIColor clearColor];
    finishView.totalDistance   = totalDistance;
    finishView.busDistance     = busDistance;
    finishView.walkingDistance = walkingDistance;
    finishView.transCount      = transCount;
    [finishView initSubViews];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:finishView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [popup show];
}

#pragma mark 视图切换
- (void)loadScrollView:(UIScrollView *)pageOfScroll withPage:(NSInteger)page
{
    [pageOfScroll setContentOffset:CGPointMake((myMapView.bounds.size.width) * page, 1)];  //UIScrollView滚动到指定位置
}

//切换视图后实现的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    //NSLog(@"page = %d",page);
    
    [self drawAnnotationAndOverlay:page];
    
    textDetailsScrollView.currentIndex = page;
    [textDetailsScrollView showOnTheView:page];
    
}

- (void)changePage:(UIPageControl *)sender
{
    [textDetailsScrollView setContentOffset:CGPointMake((myMapView.bounds.size.width) * sender.currentPage, 1)];  //UIScrollView滚动到指定位置
    
    [self drawAnnotationAndOverlay:sender.currentPage];
    
    textDetailsScrollView.currentIndex = sender.currentPage;
    [textDetailsScrollView showOnTheView:sender.currentPage];
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
            annotationView.image = [UIImage imageNamed:@"起点38x60px"];
            return annotationView;
        } else if ([wayReuslt isEqualToString:@"1"]) {
            annotationView.canShowCallout= NO;            //终点
            annotationView.image = [UIImage imageNamed:@"终点38x60px"];
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
            
            //在这里修改线路颜色
            if (wayFlag == 2 || wayFlag == 1) {
                polylineView.strokeColor = myColor;
                //polylineView.subviews
            } else if (wayFlag == 3) {
                polylineView.strokeColor = [UIColor cyanColor];
            }
            
            //polylineView.lineJoin = kCALineJoinRound;//连接类型
            //polylineView.lineCapType = kCALineCapRound;//端点类型
        } else {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor orangeColor];
            //polylineView.lineJoin = kCALineJoinRound;//连接类型
            //polylineView.lineCapType = kCALineCapRound;//端点类型
        }
        
        return polylineView;
    }
    return nil;
}

//绘制线路和标注的函数
- (void)drawAnnotationAndOverlay:(NSInteger)pageIndex
{
    
    [myMapView removeAnnotations:pointAnnotationArray];
    [myMapView removeOverlays:busPolylineArray];
    [myMapView removeOverlays:walkingPolylineArray];
    
    walkingPolylineArray = [[NSMutableArray alloc] init];
    busPolylineArray     = [[NSMutableArray alloc] init];
    pointAnnotationArray = [[NSMutableArray alloc] init];
    wayIndexArray        = [[NSMutableArray alloc] init];
    
    totalDistance   = 0;
    busDistance     = 0;
    walkingDistance = 0;
    transCount      = 0;
    
    switch (wayFlag) {
        case 1: {
            AMapTransit *transOfIndex = allRoutes.transits[pageIndex];
            NSArray *segmentArray = transOfIndex.segments;
            //NSLog(@"%@",segmentArray);
            for (AMapSegment *s in segmentArray) {
                //处理步行轨迹
                if (s.walking != nil) {
                    for (AMapStep *step in s.walking.steps) {
                        NSString *polylineStr = step.polyline;
                        //NSLog(@"%@",polylineStr);
                        MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                        [walkingPolylineArray addObject:polyline];
                    }
                    
                    AMapGeoPoint *walkingPoint = s.walking.origin;
                    walkingAnnotation = [[MAPointAnnotation alloc] init];
                    walkingAnnotation.coordinate = CLLocationCoordinate2DMake(walkingPoint.latitude, walkingPoint.longitude);
                    [pointAnnotationArray addObject:walkingAnnotation];
                    [wayIndexArray addObject:@"2"];      // 2-步行
                    
                    totalDistance += s.walking.distance;
                    walkingDistance += s.walking.distance;
                    
                }
                //处理公交路线轨迹
                if (s.busline != nil) {
                    NSString *polylineStr = s.busline.polyline;
                    MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                    [busPolylineArray addObject:polyline];
                    
                    //标注
                    AMapGeoPoint *busPoint = s.busline.departureStop.location;
                    busAnnotation = [[MAPointAnnotation alloc] init];
                    busAnnotation.coordinate = CLLocationCoordinate2DMake(busPoint.latitude, busPoint.longitude);
                    [pointAnnotationArray addObject:busAnnotation];
                    [wayIndexArray addObject:@"3"];      // 3-公交
                    
                    totalDistance += s.busline.distance;
                    busDistance   += s.busline.distance;
                    
                    transCount += 1;
                }
            }
        }
            break;
            
        case 2: {
            for (AMapPath *p in allRoutes.paths) {
                for (AMapStep *step in p.steps) {
                    NSString *polylineStr = step.polyline;
                    MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                    [walkingPolylineArray addObject:polyline];
                }
                
                walkingDistance += p.distance;
            }
        }
            break;
            
        case 3: {
            for (AMapPath *p in allRoutes.paths) {
                for (AMapStep *step in p.steps) {
                    NSString *polylineStr = step.polyline;
                    MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                    [walkingPolylineArray addObject:polyline];
                    
                }
            }
        }
            break;
            
        case 4: {
            
        }
            break;
            
        default:
            break;
    }
    
    //起点
    AMapGeoPoint *origin = allRoutes.origin;
    departureAnnotation = [[MAPointAnnotation alloc] init];
    departureAnnotation.coordinate = CLLocationCoordinate2DMake(origin.latitude, origin.longitude);
    [pointAnnotationArray addObject:departureAnnotation];
    [wayIndexArray addObject:@"0"];      // 0-起点
    
    //终点
    AMapGeoPoint *desti = allRoutes.destination;
    destiAnnotation = [[MAPointAnnotation alloc] init];
    destiAnnotation.coordinate = CLLocationCoordinate2DMake(desti.latitude, desti.longitude);
    [pointAnnotationArray addObject:destiAnnotation];
    [wayIndexArray addObject:@"1"];      // 1-终点
    
    [myMapView addAnnotations:pointAnnotationArray];
    [myMapView addOverlays:walkingPolylineArray];
    [myMapView addOverlays:busPolylineArray];
    
    //myMapView.visibleMapRect = [CommonUtility mapRectForOverlays:walkingPolylineArray];
    //设定地图的显示范围
    //具体显示的坐标我调整过
    myMapView.visibleMapRect = [CommonUtility minMapRectForAnnotations:pointAnnotationArray];
}

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

- (NSString *)findWayInAnnotationArray:(NSMutableArray *)annotationArray targetAnnotation:(MAPointAnnotation *)annotation
{
    for (int i = 0; i < annotationArray.count; i++) {
        if ([annotation isEqual:[annotationArray objectAtIndex:i]]) {
            return [wayIndexArray objectAtIndex:i];
        }
    }
    return nil;
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
