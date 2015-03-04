//
//  withBikeTransViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/26.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//  此界面显示自行车换乘的结果
//  主要的思路：首先从起点搜寻800米范围内距离起点最近的自行车站点，同时获取到达该站点的线路。接着在该自行车的3000米范围找出所有的自行车站点，之后与终点进行匹配，假如换乘次数有从大于2的变为1的，则获取该公交线路。假如没有，则从终点开始用同样的方法进行遍历

#import "withBikeTransViewController.h"

@interface withBikeTransViewController ()

@end

@implementation withBikeTransViewController

@synthesize startPoint,endPoint,bicyclePOI;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"hello");
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    bicyclePOIArray     = [[NSMutableArray alloc] init];
    findFromOriginArray = [[NSMutableArray alloc] init];
    findFromDesArray    = [[NSMutableArray alloc] init];
    
    allRoutesDictionary = [[NSMutableDictionary alloc] init];
    
    flag  = 0;
    flag2 = 0;
    flag3 = 0;
    isFind = NO;
    isBreak = NO;
    isGetOriginDis = NO;
    
    //poiNum   = 0;
    POICount = 0;
    POIIndex = 0;
    
    myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height)];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    //myMapView.userTrackingMode = MAUserTrackingModeFollow;
    //myMapView.zoomLevel = 15;
    myMapView.showsCompass = YES;
    myMapView.showsScale = YES;
    [self.view addSubview:myMapView];
    
    //构造AMapNavigationSearchRequest对象，配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviBus;
    //naviRequest.requireExtension = YES;
    naviRequest.origin = startPoint;
    naviRequest.destination = endPoint;
    naviRequest.city = @"杭州";
    //发起路径搜索
    [search AMapNavigationSearch: naviRequest];
    
    textWithBikeTransDV = [[textWithBikeTransDetailsView alloc] initWithFrame:CGRectMake(-1, myMapView.bounds.size.height - 74, myMapView.bounds.size.width + 2, self.view.bounds.size.height - 64 + 1)];
    textWithBikeTransDV.dragEnable = YES;
    [myMapView addSubview:textWithBikeTransDV];
}

/*
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    //[self callBicyclePOI:startPoint rasius:800];
    //flag2 = 1;
    //获取起始换乘总距离
    if (isGetOriginDis == NO) {
        originTotalDis = [self caculateTotalDis:response.route.transits[0]];
        isGetOriginDis = YES;
    }
    
    if (flag2 == 0) {
        //NSLog(@"bus route result");
        //flag2 = 1;
        //[self callBicyclePOI:startPoint rasius:800];
        
        if (isFind == NO) {
            if (flag == 0) {
                
                if ([self getTransCount:response.route] > 1) {
                    [self callBicyclePOI:startPoint rasius:800];   //搜寻起点3000m范围内的所有自行车站点
                    flag = 1;
                    //poiNum = 0;
                } else {
                    NSLog(@"包含换乘次数小于1的情况，直接采用此公交换乘策略");
                }
            } else if (flag == 1) {
                
                int transCount = [self getTransCount:response.route];
                
                [findFromOriginArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                NSLog(@"origin transit count = %d;",transCount);
                
                [self processBusResultData:response];
                
                //如果换乘次数减少了
                if (transCount <= 1) {
                    NSLog(@"find it!");
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    isFind = YES;
                    POIIndex = poiNum;
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    
                    //最后查找自行车线路
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.origin = bikeStartPoint;
                    naviRequest.destination = findPOI.location;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                poiNum --;
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    NSLog(@"get more near station!!");
                }
                
            } else if (flag == 2) {
                int transCount = [self getTransCount:response.route];
                
                [findFromDesArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                NSLog(@"destination transit count = %d",transCount);
                [self processBusResultData:response];
                
                if (transCount <= 1) {
                    NSLog(@"find it!");
                    isFind = YES;
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    
                    //最后查找自行车线路
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.destination = bikeStartPoint;
                    naviRequest.origin = findPOI.location;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    NSLog(@"get more near station!!");
                }
                
            }
            
            //从终点开始找
            if ([self isAllMoreThan1:findFromOriginArray]==YES && [findFromOriginArray count] == POICount) {
                [self callBicyclePOI:endPoint rasius:800];
                //findFromOriginArray = [[NSMutableArray alloc] init];
                [findFromOriginArray removeAllObjects];
                
                //bicyclePOIArray = [[NSArray alloc] init];
                flag3 = 0;
                
                flag = 2;
            }
            
            if ([self isAllMoreThan1:findFromDesArray] == YES && [findFromDesArray count] == POICount) {
                [findFromDesArray removeAllObjects];
                NSLog(@"Not Found");
            }
        } else if (isFind == YES && isBreak == NO) {
            NSLog(@"bike route result");
            //NSLog(@"bike route = %@",response.route.paths);
            isBreak = YES;
            
            bikeRoute = response.route;
            
            [self drawAnnotationAndOverlay];
        }

        
    } else {
        NSLog(@"walking result");
        flag2 = 0;
        walkingRoute = response.route;  //存储步行路线
        //NSLog(@"walking route = %@",response.route.paths);
    }
}
*/

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    //[self callBicyclePOI:startPoint rasius:800];
    //flag2 = 1;
    //获取起始换乘总距离
    if (isGetOriginDis == NO) {
        originTotalDis = [self caculateTotalDis:response.route.transits[0]];
        isGetOriginDis = YES;
    }
    
    if (flag2 == 0) {
        //NSLog(@"bus route result");
        //flag2 = 1;
        //[self callBicyclePOI:startPoint rasius:800];
        
        if (isFind == NO) {
            if (flag == 0) {
                
                if ([self getTransCount:response.route] > 1) {
                    [self callBicyclePOI:startPoint rasius:800];   //搜寻起点3000m范围内的所有自行车站点
                    flag = 1;
                    poiNum = 0;
                } else {
                    NSLog(@"包含换乘次数小于1的情况，直接采用此公交换乘策略");
                    busRoute = response.route;
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    [self drawAnnotationAndOverlay];
                    
                    textWithBikeTransDV.flag = flag;
                    textWithBikeTransDV.busName = [self processBusResultData:response];
                    textWithBikeTransDV.allRoutesDictionary = allRoutesDictionary;
                    [textWithBikeTransDV buildingView];
                }
            } else if (flag == 1) {
                
                int transCount = [self getTransCount:response.route];
                
                [findFromOriginArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                //NSLog(@"origin transit count = %d;",transCount);
                //NSLog(@"busname = %@",[self processBusResultData:response]);
                
                //如果换乘次数减少了
                if (transCount <= 1) {
                    NSLog(@"find it!");
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    isFind = YES;
                    POIIndex = poiNum;
                    bicyclePOI = findPOI;
                    busRoute = response.route;
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    busName = [self processBusResultData:response];
                    
                    //最后查找自行车线路
                    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];   //此处需要重新初始化，把原先公交查询的search给释放掉，下面同理
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.origin = bikeStartPoint;
                    naviRequest.destination = response.route.origin;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    NSLog(@"get more near station!!");
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    isFind = YES;
                    POIIndex = poiNum;
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    NSLog(@"find bike Point = %@",findPOI.location);
                    
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    busName = [self processBusResultData:response];
                    
                    //最后查找自行车线路
                    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.origin = bikeStartPoint;
                    naviRequest.destination = response.route.origin;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //NSLog(@"poiNum = %ld",(long)poiNum);
                
                poiNum --;
                
            } else if (flag == 2) {
                int transCount = [self getTransCount:response.route];
                
                [findFromDesArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                NSLog(@"destination transit count = %d",transCount);
                [self processBusResultData:response];
                
                if (transCount <= 1) {
                    NSLog(@"find it!");
                    isFind = YES;
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    NSLog(@"find bike Point = %@",findPOI.location);
                    busName = [self processBusResultData:response];
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    
                    //最后查找自行车线路
                    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.destination = bikeStartPoint;
                    naviRequest.origin = response.route.destination;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    NSLog(@"get more near station!!");
                    
                    isFind = YES;
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    NSLog(@"the bicyce station is:%@",findPOI.name);
                    bicyclePOI = findPOI;
                    busRoute = response.route;
                    NSLog(@"find bike Point = %@",findPOI.location);
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    busName = [self processBusResultData:response];
                    
                    //最后查找自行车线路
                    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.destination = bikeStartPoint;
                    naviRequest.origin = response.route.destination;
                    naviRequest.city = @"杭州";
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
            }
            
            //从终点开始找
            if ([self isAllMoreThan1:findFromOriginArray]==YES && [findFromOriginArray count] == POICount) {
                [self callBicyclePOI:endPoint rasius:800];
                //findFromOriginArray = [[NSMutableArray alloc] init];
                [findFromOriginArray removeAllObjects];
                
                //bicyclePOIArray = [[NSArray alloc] init];
                flag3 = 0;
                
                flag = 2;
            }
            
            if ([self isAllMoreThan1:findFromDesArray] == YES && [findFromDesArray count] == POICount) {
                [findFromDesArray removeAllObjects];
                NSLog(@"Not Found");
            }
        } else if (isFind == YES && isBreak == NO) {
            NSLog(@"bike route result");
            //NSLog(@"bike route = %@",response.route);
            isBreak = YES;
            
            bikeRoute = response.route;
            
            [self drawAnnotationAndOverlay];
            
            [allRoutesDictionary setObject:response.route forKey:@"bike"];
            
            textWithBikeTransDV.flag = flag;
            textWithBikeTransDV.busName = busName;
            textWithBikeTransDV.allRoutesDictionary = allRoutesDictionary;
            [textWithBikeTransDV buildingView];
        }
        
        
    } else {
        NSLog(@"walking result");
        flag2 = 0;
        walkingRoute = response.route;  //存储步行路线
        
        [allRoutesDictionary setObject:response.route forKey:@"walking"];
        
    }
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{

    if (flag3 == 0) {
        NSLog(@"800m result");
        if (response.pois.count == 0) {
            NSLog(@"附近未找到公共自行车站点！");
        } else {
            if (flag == 1) {
                AMapPOI *poi = response.pois[0];
                
                bikeStartPoint = poi.location;
                
                //NSLog(@"bikeStartPoint = %@")
                
                [self callBicyclePOI:poi.location rasius:3000];
                
                AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                naviRequest.searchType = AMapSearchType_NaviWalking;
                //naviRequest.requireExtension = YES;
                naviRequest.origin = startPoint;
                naviRequest.destination = poi.location;
                naviRequest.city = @"杭州";
                //发起路径搜索
                [search AMapNavigationSearch: naviRequest];
            } else if (flag == 2) {
                AMapPOI *poi = response.pois[0];
                
                bikeStartPoint = poi.location;
                
                [self callBicyclePOI:poi.location rasius:3000];
                
                AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                naviRequest.searchType = AMapSearchType_NaviWalking;
                //naviRequest.requireExtension = YES;
                naviRequest.origin = poi.location;
                naviRequest.destination = endPoint;
                naviRequest.city = @"杭州";
                //发起路径搜索
                [search AMapNavigationSearch: naviRequest];
            }

            
            flag2 = 1;
            
            flag3 = 1;
        }
        
    } else {
        //bicyclePOIArray = response.pois;
        poiNum = response.pois.count - 1;
        
        POICount = response.pois.count;
        NSLog(@"3000m result");
        if (flag == 1) {
            for (NSInteger i = response.pois.count - 1; i >= 0; i --) {
                //从最远距离搜索，提高搜索效率
                AMapPOI *p = response.pois[i];
                [bicyclePOIArray addObject:p];
                [self callBusRouteWithLocationOrigin:p.location locationDes:endPoint];
            }
        } else if (flag == 2) {

            //从最远距离搜索，提高搜索效率
            for (NSInteger i = response.pois.count - 1; i >= 0; i --) {
                AMapPOI *p = response.pois[i];
                [bicyclePOIArray addObject:p];
                [self callBusRouteWithLocationOrigin:startPoint locationDes:p.location];
            }
        }
    }
    
}

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

- (void)callBusRouteWithLocationOrigin:(AMapGeoPoint *)originPoint locationDes:(AMapGeoPoint *)desPoint
{
    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    //构造AMapNavigationSearchRequest对象，配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviBus;
    //naviRequest.requireExtension = YES;
    naviRequest.origin = originPoint;
    naviRequest.destination = desPoint;
    naviRequest.city = @"杭州";
    //发起路径搜索
    [search AMapNavigationSearch: naviRequest];
}

- (NSString *)processBusResultData:(AMapNavigationSearchResponse *)response
{
    
    NSString *tempbusName = [[NSString alloc] init];
    
    // -- * 处理公交线路名称 * --
    for (AMapTransit *t in response.route.transits) {
        
        if (t.segments.count <= 2) {             //不需要换乘
            for (AMapSegment *s in t.segments) {
                
                if (s.busline != nil) {
                    tempbusName = [self busNameTrans:s.busline.name];
                }
            }
        } else {                                 //有换乘
            int i = 0;
            NSString *tmpStr = [[NSString alloc] init];
            for (AMapSegment *s in t.segments) {
                if (s.busline != nil) {
                    
                    //截取括号之前的线路名称
                    tmpStr = [self busNameTrans:s.busline.name];
                    
                    if (i > 0) {
                        tempbusName = [tempbusName stringByAppendingString:[NSString stringWithFormat:@"→%@",tmpStr]];
                    } else {
                        tempbusName = tmpStr;
                    }
                    i++;
                }
            }
        }
        
        //NSLog(@"busName = %@",busName);
        return tempbusName;
        
    }
    
    return nil;
}

//绘制线路和标注的函数
- (void)drawAnnotationAndOverlay
{
    pointAnnotationArray = [[NSMutableArray alloc] init];
    
    walkingPolylineArray = [[NSMutableArray alloc] init];
    bikePolylineArray    = [[NSMutableArray alloc] init];
    busPolylineArray     = [[NSMutableArray alloc] init];
    
    //处理步行线路
    for (AMapPath *p in walkingRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [walkingPolylineArray addObject:polyline];
        }
    }
    
    //处理自行车线路
    for (AMapPath *p in bikeRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [bikePolylineArray addObject:polyline];
        }
    }
    
    //处理公交线路
    AMapTransit *transit0 = busRoute.transits[0];
    NSArray *segmentArray = transit0.segments;
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
        }
    }
    
    //添加标注
    /*
    AMapGeoPoint *walkOrigin = walkingRoute.origin;
    MAPointAnnotation *walkOriginAnnotation = [[MAPointAnnotation alloc] init];
    walkOriginAnnotation.coordinate = CLLocationCoordinate2DMake(walkOrigin.latitude, walkOrigin.longitude);
    [pointAnnotationArray addObject:walkOriginAnnotation];
    
    AMapGeoPoint *walkDes = walkingRoute.destination;
    MAPointAnnotation *walkDesAnnotation = [[MAPointAnnotation alloc] init];
    walkDesAnnotation.coordinate = CLLocationCoordinate2DMake(walkDes.latitude, walkDes.longitude);
    [pointAnnotationArray addObject:walkDesAnnotation];
    
    AMapGeoPoint *bikeOrigin = bikeRoute.origin;
    MAPointAnnotation *bikeOriginAnnotation = [[MAPointAnnotation alloc] init];
    bikeOriginAnnotation.coordinate = CLLocationCoordinate2DMake(bikeOrigin.latitude, bikeOrigin.longitude);
    [pointAnnotationArray addObject:bikeOriginAnnotation];
    
    AMapGeoPoint *bikeDes = bikeRoute.destination;
    MAPointAnnotation *bikeDesAnnotation = [[MAPointAnnotation alloc] init];
    bikeDesAnnotation.coordinate = CLLocationCoordinate2DMake(bikeDes.latitude, bikeDes.longitude);
    [pointAnnotationArray addObject:bikeDesAnnotation];
    
    AMapGeoPoint *busOrigin = busRoute.origin;
    MAPointAnnotation *busOriginAnnotation = [[MAPointAnnotation alloc] init];
    busOriginAnnotation.coordinate = CLLocationCoordinate2DMake(busOrigin.latitude, busOrigin.longitude);
    [pointAnnotationArray addObject:busOriginAnnotation];
    
    AMapGeoPoint *busDes = busRoute.destination;
    MAPointAnnotation *busDesAnnotation = [[MAPointAnnotation alloc] init];
    busDesAnnotation.coordinate = CLLocationCoordinate2DMake(busDes.latitude, busDes.longitude);
    [pointAnnotationArray addObject:busDesAnnotation];
    */
    
    AMapGeoPoint *busOrigin = startPoint;
    MAPointAnnotation *busOriginAnnotation = [[MAPointAnnotation alloc] init];
    busOriginAnnotation.coordinate = CLLocationCoordinate2DMake(busOrigin.latitude, busOrigin.longitude);
    [pointAnnotationArray addObject:busOriginAnnotation];
    
    AMapGeoPoint *busDes = endPoint;
    MAPointAnnotation *busDesAnnotation = [[MAPointAnnotation alloc] init];
    busDesAnnotation.coordinate = CLLocationCoordinate2DMake(busDes.latitude, busDes.longitude);
    [pointAnnotationArray addObject:busDesAnnotation];
    
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
            polylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
            //polylineView.lineJoin = kCALineJoinRound;//连接类型
            //polylineView.lineCapType = kCALineCapRound;//端点类型
        } else if ([self isInArray:bikePolylineArray target:overlay]) {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
            
        } else {
            polylineView.lineWidth = 10.f;
            polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        }
        
        return polylineView;
    }
    return nil;
}

//计算总路程
- (NSInteger)caculateTotalDis:(AMapTransit *)t
{
    NSInteger totalDistance = 0;       //单位：米
    for (AMapSegment *s in t.segments) {
        NSInteger walkDis = s.walking.distance;
        NSInteger busDis = s.busline.distance;
        totalDistance += walkDis + busDis;
    }
    
    return totalDistance;
    
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

//查找数组是否全部大于1
- (BOOL)isAllMoreThan1:(NSMutableArray *)array
{
    if (array.count == 0) {
        return NO;
    }
    
    for (NSString *s in array) {
        if ([s intValue] <= 1) {
            return NO;
        }
    }
    
    return YES;
}

//线路名称处理函数
- (NSString *)busNameTrans:(NSString *)originName
{
    NSRange subRange = [originName rangeOfString:@"("];
    if (subRange.length == 0 && subRange.location == 0) {
        return originName;
    } else {
        return [originName substringToIndex:subRange.location];
    }
}

//计算换乘次数
- (int)getTransCount:(AMapRoute *)route
{
    AMapTransit *transit = route.transits[0];
    int transCount = 0;
    for (AMapSegment *s in transit.segments) {
        if (s.busline != nil) {
            transCount ++;
        }
    }
    
    return transCount;
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
