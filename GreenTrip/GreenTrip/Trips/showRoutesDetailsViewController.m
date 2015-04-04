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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //NSLog(@"hello@@");
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBarHidden = NO;
    
    //NSLog(@"Hello@");
    
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
    
    //不知为何真机测试数据显示刷要两次，难道是BUG??
    [self drawAnnotationAndOverlay:index];
    [self drawAnnotationAndOverlay:index];
    
    if (wayFlag == 1) {
        self.navigationItem.title = @"公交路线";
        textDetailsScrollView = [[textRoutesDetailsScrollView alloc] initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 134, myMapView.bounds.size.width, self.view.bounds.size.height - 64 + 1)];
        
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
        textWRDView = [[textWalkingRoutesDetailsView alloc] initWithFrame:CGRectMake(0, myMapView.bounds.size.height - 134, myMapView.bounds.size.width, self.view.bounds.size.height - 64 + 1)];
        textWRDView.dragEnable = YES;
        textWRDView.walkingRoute = allRoutes;
        textWRDView.startName = startName;
        textWRDView.endName = endName;
        textWRDView.wayFlag = wayFlag;
        
        [myMapView addSubview:textWRDView];
        [textWRDView buildingView];
                                                                                     
    } else if (wayFlag == 3) {                //自行车线路
        self.navigationItem.title = @"自行车路线";
        textWRDView = [[textWalkingRoutesDetailsView alloc] initWithFrame:CGRectMake(-1, myMapView.bounds.size.height - 134, myMapView.bounds.size.width + 2, self.view.bounds.size.height - 64 + 1)];
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
        if ([annotation isEqual:departureAnnotation]) {    //区分不同的类型
            static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
            //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
            //annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
            annotationView.pinColor = MAPinAnnotationColorPurple;
            return annotationView;
        } else {
            static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
            //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
            //annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
            annotationView.pinColor = MAPinAnnotationColorRed;
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
                polylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
            } else if (wayFlag == 3) {
                polylineView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
            }
            
            //polylineView.lineJoin = kCALineJoinRound;//连接类型
            //polylineView.lineCapType = kCALineCapRound;//端点类型
        } else {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
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
    busPolylineArray = [[NSMutableArray alloc] init];
    pointAnnotationArray = [[NSMutableArray alloc] init];
    
    switch (wayFlag) {
        case 1: {
            AMapTransit *transOfIndex = allRoutes.transits[pageIndex];
            NSArray *segmentArray = transOfIndex.segments;
            for (AMapSegment *s in segmentArray) {
                //处理步行轨迹
                if (s.walking != nil) {
                    for (AMapStep *step in s.walking.steps) {
                        NSString *polylineStr = step.polyline;
                        //NSLog(@"%@",polylineStr);
                        MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                        [walkingPolylineArray addObject:polyline];
                    }
                }
                //处理公交路线轨迹
                if (s.busline != nil) {
                    NSString *polylineStr = s.busline.polyline;
                    MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
                    [busPolylineArray addObject:polyline];
                    
                    //标注
                    AMapGeoPoint *busDepartrue = s.busline.departureStop.location;
                    departureAnnotation = [[MAPointAnnotation alloc] init];
                    departureAnnotation.coordinate = CLLocationCoordinate2DMake(busDepartrue.latitude, busDepartrue.longitude);
                    [pointAnnotationArray addObject:departureAnnotation];
                    //[myMapView addAnnotation:departureAnnotation];
                    
                    //[pointAnnotationArray addObject:departureAnnotation];
                    
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
    MAPointAnnotation *originAnnotation = [[MAPointAnnotation alloc] init];
    originAnnotation.coordinate = CLLocationCoordinate2DMake(origin.latitude, origin.longitude);
    [pointAnnotationArray addObject:originAnnotation];
    
    //终点
    AMapGeoPoint *desti = allRoutes.destination;
    destiAnnotation = [[MAPointAnnotation alloc] init];
    destiAnnotation.coordinate = CLLocationCoordinate2DMake(desti.latitude, desti.longitude);
    [myMapView addAnnotation:destiAnnotation];
    [pointAnnotationArray addObject:destiAnnotation];
    
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
