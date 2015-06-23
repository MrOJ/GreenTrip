//
//  withBikeTransViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/2/26.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//  此界面显示自行车换乘的结果
//  主要的思路：首先从起点搜寻800米范围内距离起点最近的自行车站点，同时获取到达该站点的线路。接着在该自行车的3000米范围找出所有的自行车站点，之后与终点进行匹配，假如换乘次数有从大于2的变为1的，则获取该公交线路。假如没有，则从终点开始用同样的方法进行遍历

#import "withBikeTransViewController.h"
#import "YDConfigurationHelper.h"

@interface withBikeTransViewController ()

@end

@implementation withBikeTransViewController

@synthesize startPoint,endPoint,bicyclePOI,startName,endName;
@synthesize indicatorButton,scalingView,increaseButton,decreaseButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"hello");
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"绿色箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"结束行程" style:UIBarButtonItemStylePlain target:self action:@selector(finishTrip:)];
    self.navigationItem.rightBarButtonItem = registerButton;
    
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
    
    myTotalDistance = 0;
    myBusDistance   = 0;
    myWalkingDistance = 0;
    myBikeDistance    = 0;
    myTransCount      = 0;
    
    isFinishTrip = 0;
    
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
    
    //构造AMapNavigationSearchRequest对象，配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviBus;
    //naviRequest.requireExtension = YES;
    naviRequest.origin = startPoint;
    naviRequest.destination = endPoint;
    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
    //发起路径搜索
    [search AMapNavigationSearch: naviRequest];
    
    textWithBikeTransDV = [[textWithBikeTransDetailsView alloc] initWithFrame:CGRectMake(-1, myMapView.bounds.size.height - 134 - 14, myMapView.bounds.size.width + 2, self.view.bounds.size.height - 64 + 1 )];
    textWithBikeTransDV.dragEnable = YES;
    textWithBikeTransDV.startName = startName;
    textWithBikeTransDV.endName = endName;
    [myMapView addSubview:textWithBikeTransDV];
    
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
    
    if (isFinishTrip == 0) {
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
                finishView.totalDistance   = myTotalDistance;
                finishView.busDistance     = myBusDistance;
                finishView.walkingDistance = myWalkingDistance;
                finishView.bikeDistance    = myBikeDistance;
                finishView.transCount      = myTransCount;
                
                finishView.departurePoint  = startPoint;
                finishView.arrivalTime     = Timestr;
                finishView.arrivalPoint    = endPoint;
                finishView.strategy        = 4;     //4表示混合
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

# pragma searchDelegate
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    //[self callBicyclePOI:startPoint rasius:800];
    //flag2 = 1;
    //获取起始换乘总距离
    if(response.count == 0)
    {
        [activityIndicatorView stopAnimating];
        
        NSLog(@"未找到对应线路,请重试!");
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        //HUD.yOffset = -100;     //改变位置
        HUD.mode = MBProgressHUDModeText;
        
        HUD.delegate = self;
        HUD.labelText = @"未找到该线路策略，请尝试其他策略";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
        return;
    }
    
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
                    //修改次数用于改变策略！！
                    //如果flag为1，则从起点搜索，flag为2，则从终点搜索，确定选择的按钮在哪儿
                    flag = 1;
                    
                    if (flag == 1) {
                        [self callBicyclePOI:startPoint rasius:800];   //搜寻起点3000m范围内的所有自行车站点
                    } else {
                        [self callBicyclePOI:endPoint rasius:800];   //搜寻起点3000m范围内的所有自行车站点
                    }
                    
                    poiNum = 0;
                } else {
                    NSLog(@"包含换乘次数小于1的情况，直接采用此公交换乘策略");
                    busRoute = response.route;
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    [self drawAnnotationAndOverlay];
                    
                    textWithBikeTransDV.flag = flag;
                    textWithBikeTransDV.busName             = busName;
                    //textWithBikeTransDV.startBikeStopName   = startBikeStopName;
                    //textWithBikeTransDV.endBikeStopName     = endBikeStopName;
                    textWithBikeTransDV.busName = [self processBusResultData:response];
                    textWithBikeTransDV.allRoutesDictionary = allRoutesDictionary;
                    [textWithBikeTransDV buildingView];
                    
                    [activityIndicatorView stopAnimating];
                }
            } else if (flag == 1) {
                
                int transCount = [self getTransCount:response.route];
                
                [findFromOriginArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                //NSLog(@"origin transit count = %d;",transCount);
                //NSLog(@"busname = %@",[self processBusResultData:response]);
                
                //如果换乘次数减少了
                if (transCount <= 1) {
                    //NSLog(@"find it!");
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    //NSLog(@"the bicyce station is:%@",findPOI.name);
                    endBikeStopName = findPOI.name;
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
                    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    //NSLog(@"get more near station!!");
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    //NSLog(@"the bicyce station is:%@",findPOI.name);
                    endBikeStopName = findPOI.name;
                    isFind = YES;
                    POIIndex = poiNum;
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    //NSLog(@"find bike Point = %@",findPOI.location);
                    
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    busName = [self processBusResultData:response];
                    
                    //最后查找自行车线路
                    
                    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.origin = bikeStartPoint;
                    naviRequest.destination = response.route.origin;
                    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                    
                    //NSLog(@"bike request = %@",naviRequest);
                }
                
                //NSLog(@"poiNum = %ld",(long)poiNum);
                
                poiNum --;
                
            } else if (flag == 2) {
                int transCount = [self getTransCount:response.route];
                
                [findFromDesArray addObject:[NSString stringWithFormat:@"%d",transCount]];
                
                NSLog(@"destination transit count = %d",transCount);
                [self processBusResultData:response];
                
                if (transCount <= 1) {
                    //NSLog(@"find it!");
                    isFind = YES;
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    //NSLog(@"the bicyce station is:%@",findPOI.name);
                    
                    endBikeStopName = findPOI.name;
                    
                    bicyclePOI = findPOI;
                    
                    busRoute = response.route;
                    //NSLog(@"find bike Point = %@",findPOI.location);
                    busName = [self processBusResultData:response];
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    
                    //最后查找自行车线路
                    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.destination = bikeStartPoint;
                    naviRequest.origin = response.route.destination;
                    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
                    //发起路径搜索
                    [search AMapNavigationSearch: naviRequest];
                }
                
                //如何总的距离减少了
                NSInteger curTotalDis = [self caculateTotalDis:response.route.transits[0]];
                if (curTotalDis < originTotalDis) {
                    //NSLog(@"get more near station!!");
                    
                    isFind = YES;
                    
                    AMapPOI *findPOI = [bicyclePOIArray objectAtIndex:poiNum];
                    //NSLog(@"the bicyce station is:%@",findPOI.name);
                    endBikeStopName = findPOI.name;
                    bicyclePOI = findPOI;
                    busRoute = response.route;
                    //NSLog(@"find bike Point = %@",findPOI.location);
                    [allRoutesDictionary setObject:response.route forKey:@"bus"];
                    busName = [self processBusResultData:response];
                    
                    
                    //最后查找自行车线路
                    //search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
                    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                    naviRequest.searchType = AMapSearchType_NaviWalking;
                    //naviRequest.requireExtension = YES;
                    naviRequest.destination = bikeStartPoint;
                    naviRequest.origin = response.route.destination;
                    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
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
        } else if (isFind == YES && isBreak == NO && request.searchType == 17) {
            //NSLog(@"bike route result");
            //NSLog(@"bike route = %@",response.route);
            //NSLog(@"request = %@",request);
            //isBreak = YES;
            [activityIndicatorView stopAnimating];
            
            bikeRoute = response.route;
            
            [self drawAnnotationAndOverlay];
            
            [allRoutesDictionary setObject:response.route forKey:@"bike"];
            
            textWithBikeTransDV.flag                = flag;
            textWithBikeTransDV.busName             = busName;
            textWithBikeTransDV.startBikeStopName   = startBikeStopName;
            textWithBikeTransDV.endBikeStopName     = endBikeStopName;
            textWithBikeTransDV.allRoutesDictionary = allRoutesDictionary;
            [textWithBikeTransDV buildingView];
        }
        
        
    } else {
        //NSLog(@"walking result");
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
                startBikeStopName = poi.name;
                //NSLog(@"bikeStartPoint = %@")
                
                [self callBicyclePOI:poi.location rasius:3000];
                
                AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                naviRequest.searchType = AMapSearchType_NaviWalking;
                //naviRequest.requireExtension = YES;
                naviRequest.origin = startPoint;
                naviRequest.destination = poi.location;
                naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
                //发起路径搜索
                [search AMapNavigationSearch: naviRequest];
            } else if (flag == 2) {
                AMapPOI *poi = response.pois[0];
                
                bikeStartPoint = poi.location;
                startBikeStopName = poi.name;
                
                [self callBicyclePOI:poi.location rasius:3000];
                
                AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
                naviRequest.searchType = AMapSearchType_NaviWalking;
                //naviRequest.requireExtension = YES;
                naviRequest.origin = poi.location;
                naviRequest.destination = endPoint;
                naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
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

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
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
    naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
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
    wayIndexArray        = [[NSMutableArray alloc] init];
    
    //处理步行线路
    for (AMapPath *p in walkingRoute.paths) {
        for (AMapStep *step in p.steps) {
            NSString *polylineStr = step.polyline;
            //NSLog(@"%@",polylineStr);
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [walkingPolylineArray addObject:polyline];
        }
        
        AMapGeoPoint *walkingPoint = walkingRoute.origin;
        MAPointAnnotation *walkingAnnotation = [[MAPointAnnotation alloc] init];
        walkingAnnotation.coordinate = CLLocationCoordinate2DMake(walkingPoint.latitude, walkingPoint.longitude);
        [pointAnnotationArray addObject:walkingAnnotation];
        [wayIndexArray addObject:@"2"];      // 2-步行
        
        myTotalDistance   += p.distance;
        myWalkingDistance += p.distance;
        
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
        
        myTotalDistance += p.distance;
        myBikeDistance  += p.distance;
        
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
            
            AMapGeoPoint *walkingPoint = walkingRoute.origin;
            if (walkingPoint) {
                MAPointAnnotation *walkingAnnotation = [[MAPointAnnotation alloc] init];
                walkingAnnotation.coordinate = CLLocationCoordinate2DMake(walkingPoint.latitude, walkingPoint.longitude);
                [pointAnnotationArray addObject:walkingAnnotation];
                [wayIndexArray addObject:@"2"];      // 2-步行
                
                myTotalDistance   += s.walking.distance;
                myWalkingDistance += s.walking.distance;
            }
        }
        //处理公交路线轨迹
        if (s.busline != nil) {
            NSString *polylineStr = s.busline.polyline;
            MAPolyline *polyline = [self polylineStrToGeoPoint:polylineStr];
            [busPolylineArray addObject:polyline];
            
            AMapGeoPoint *busPoint = s.busline.departureStop.location;
            if (busPoint) {
                MAPointAnnotation *busAnnotation = [[MAPointAnnotation alloc] init];
                busAnnotation.coordinate = CLLocationCoordinate2DMake(busPoint.latitude, busPoint.longitude);
                [pointAnnotationArray addObject:busAnnotation];
                [wayIndexArray addObject:@"3"];      // 3-公交
                
                myTotalDistance += s.busline.distance;
                myBusDistance   += s.busline.distance;
                
                myTransCount += 1;
            }

        }
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

    for (MAPointAnnotation *a in pointAnnotationArray) {
        NSLog(@"(%f,%f)",a.coordinate.latitude,a.coordinate.longitude);
    }
    
    //NSLog(@"annontation %@",pointAnnotationArray);
    myMapView.visibleMapRect = [CommonUtility minMapRectForAnnotations:pointAnnotationArray];
    //myMapView.visibleMapRect = [CommonUtility minMapRectForAnnotations:pointAnnotationArray];
    NSLog(@"%f,%f,%f,%f",myMapView.visibleMapRect.origin.x,myMapView.visibleMapRect.origin.y,myMapView.visibleMapRect.size.width,myMapView.visibleMapRect.size.height);
    
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

- (NSString *)findWayInAnnotationArray:(NSMutableArray *)annotationArray targetAnnotation:(MAPointAnnotation *)annotation
{
    for (int i = 0; i < annotationArray.count; i++) {
        if ([annotation isEqual:[annotationArray objectAtIndex:i]]) {
            return [wayIndexArray objectAtIndex:i];
        }
    }
    return nil;
}

/*
#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
