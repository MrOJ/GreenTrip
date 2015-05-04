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

@synthesize _mapView,myMapView,titleV,startButton,indicatorButton,scalingView,indicatorTag;
@synthesize bikeSearchButton;
@synthesize increaseButton,decreaseButton,searchTableView,searchIconView,searchView;
@synthesize searchTextField;

@synthesize tipsResultTableView,myUserLocation,bikePOIArray;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.navigationItem.title = @"绿出行";
    self.navigationController.navigationBar.barTintColor = myColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    textStr = [[NSString alloc] init];
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";    //
    
    myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), CGRectGetHeight(_mapView.bounds))];
    myMapView.delegate = self;
    myMapView.layer.cornerRadius = 5;
    myMapView.showsUserLocation = YES;
    myMapView.userTrackingMode = MAUserTrackingModeFollow;
    myMapView.zoomLevel = 15;
    myMapView.showsCompass = NO;
    myMapView.showsScale = NO;
    [_mapView addSubview:myMapView];
    
    titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height)];
    //titleV.backgroundColor = myColor;
    [self.navigationItem.titleView addSubview:titleV];
    
    //startButton.layer.masksToBounds = YES;
    startButton.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    startButton.layer.shadowOpacity = 0.3f;

    //indicatorButton.layer.masksToBounds = YES;
    indicatorButton.layer.shadowOffset = CGSizeMake(1, 1);
    indicatorButton.layer.shadowOpacity = 0.3f;
    //[indicatorButton setImage:[UIImage imageNamed:@"指南140x140选中.png"] forState:UIControlStateSelected];
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140.png"] forState:UIControlStateNormal];
    indicatorTag = 0;
    //indicatorTag = 0;
    
    //scalingView.layer.masksToBounds = YES;
    scalingView.layer.shadowOffset = CGSizeMake(1, 1);
    scalingView.layer.shadowOpacity = 0.3f;
    scalingView.layer.cornerRadius = 3.0f;
    
    bikeSearchButton.layer.shadowOffset = CGSizeMake(0.5, 0.0);
    bikeSearchButton.layer.shadowOpacity = 0.25f;
    bikeSearchButton.layer.cornerRadius = 1.0f;
    
    searchView.layer.shadowOffset = CGSizeMake(0.5, 0);
    searchView.layer.shadowOpacity = 0.25f;
    searchView.layer.cornerRadius = 1.0f;
    
    searchTextField.delegate = self;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.enablesReturnKeyAutomatically = YES;
    
    tipsResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 11 + searchTextField.bounds.size.height, self.view.bounds.size.width - 30 - 50 - 13, 385)];
    tipsResultTableView.delegate = self;
    tipsResultTableView.dataSource = self;
    tipsResultTableView.hidden = YES;

    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(15, 11 + searchTextField.bounds.size.height, (self.view.bounds.size.width - 30 - 50 - 13 ), 35)];
    
    UIButton *busButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, (self.view.bounds.size.width - 30 - 50 - 13 ) / 3, 35)];
    [busButton setTitle:@"地点" forState:UIControlStateNormal];
    busButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [busButton setBackgroundColor:myColor];
    
    UIButton *routeButton = [[UIButton alloc]initWithFrame:CGRectMake(0 + (self.view.bounds.size.width - 30 - 50 - 13 ) / 3, 0, (self.view.bounds.size.width - 30 - 50 - 13 ) / 3, 35)];
    [routeButton setTitle:@"公交线" forState:UIControlStateNormal];
    routeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [routeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [routeButton setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *bikePlaceButton = [[UIButton alloc]initWithFrame:CGRectMake(0 + (self.view.bounds.size.width - 30 - 50 - 13 ) / 3 * 2, 0, (self.view.bounds.size.width - 30 - 50 - 13 ) / 3, 35)];
    [bikePlaceButton setTitle:@"自行车站" forState:UIControlStateNormal];
    bikePlaceButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [bikePlaceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bikePlaceButton setBackgroundColor:[UIColor whiteColor]];
    
    [chooseView addSubview:busButton];
    [chooseView addSubview:routeButton];
    [chooseView addSubview:bikePlaceButton];
    tipsResultTableView.tableHeaderView = chooseView;
    
    [myMapView addSubview:tipsResultTableView];
    
    
    [myMapView addSubview:indicatorButton];
    [myMapView addSubview:startButton];
    [myMapView addSubview:scalingView];
    [myMapView addSubview:bikeSearchButton];
    [myMapView addSubview:searchView];
    
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [_mapView addGestureRecognizer:tapGesture];
    
    myAlert = [[UIAlertView alloc] initWithTitle:nil message:@"搜索到附近800m范围自行车站点" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
}

- (IBAction)getIndicator:(id)sender {
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
        myMapView.zoomLevel = 15.0f;
        myMapView.userTrackingMode = MAUserTrackingModeFollow;
        indicatorButton.selected = YES;
        [indicatorButton setImage:[UIImage imageNamed:@"指南140x140选中"] forState:UIControlStateSelected];
        indicatorTag = 1;
        //mapView.showsCompass = NO;
    }
    
    //indicatorButton.selected = YES;
    //NSLog(@"Hello!");
    
}

- (IBAction)increaseScaling:(id)sender {
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
    //NSLog(@"zoomlevel = %f",mapView.zoomLevel);
    //NSLog(@"maxzoomlevel = %f",mapView.maxZoomLevel);
}

- (IBAction)decreaseScaling:(id)sender {
    //NSLog(@"zoomlevel = %f",mapView.zoomLevel);
    //NSLog(@"minzoomlevel = %f",mapView.minZoomLevel);
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

- (IBAction)bikePointSearch:(id)sender {
    
    [myMapView removeAnnotations:bikePOIArray];
    
    bikePOIArray = [[NSMutableArray alloc] init];
    
    searchTextField.text = @"";
    tipsResultTableView.hidden = YES;
    [searchTextField resignFirstResponder];
    
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:myUserLocation.coordinate.latitude longitude:myUserLocation.coordinate.longitude];//固定的站点，难怪不会实时动态更新
    poiRequest.keywords = @"自行车租赁点";
    poiRequest.radius= 800;
    [search AMapPlaceSearch: poiRequest];
}

# pragma TextField
-(BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"hello");
    textStr = field.text;
    textStr = [textStr stringByReplacingCharactersInRange:range withString:string];     //其中的字符串用string代替
    //NSLog(@"textStr = %@", textStr);
    
    if ([textStr isEqualToString:@""]) {
        tipsResultTableView.hidden = YES;
        searchTextField.text = @"";
        [searchTextField resignFirstResponder];
    } else {
        tipsResultTableView.hidden = NO;

        AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
        tipsRequest.searchType = AMapSearchType_InputTips;
        tipsRequest.keywords = textStr;
        //tipsRequest.city = @[@"杭州"];    //之后会修改
        
        [search AMapInputTipsSearch:tipsRequest];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    tipsResultTableView.hidden = YES;
    
    return YES;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [searchTextField resignFirstResponder];
    
}

//点击return取消键盘

- (BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma AmapTipsSearch
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    nameArray = [[NSMutableArray alloc] init];
    districtArray =[[NSMutableArray alloc] init];
    
    if(response.tips.count == 0)
    {
        return;
    }
    
    for (AMapTip *p in response.tips) {
        [nameArray addObject:p.name];
        [districtArray addObject:p.district];
    }
    
    [tipsResultTableView reloadData];
    
}

#pragma place seach results
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if (response.pois.count == 0) {
        //NSLog(@"附近未找到公共自行车站点！");
        myAlert = [[UIAlertView alloc] initWithTitle:@"查找失败" message:@"附近未找到公共自行车站点" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        //[alert show];
    } else {
        for (AMapPOI *poi in response.pois) {
            MAPointAnnotation *pointAnn = [[MAPointAnnotation alloc] init];
            pointAnn.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            pointAnn.title = poi.name;
            
            [bikePOIArray addObject:pointAnn];
            
        }
        
        //NSLog(@"%lu",(unsigned long)bikePOIArray.count);

        
        [myMapView addAnnotations:bikePOIArray];
        //AMapGeoPoint *poi = response.pois[0];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector: @selector(performDismiss:)  userInfo:nil repeats:NO];
    [myAlert show];
}


- (void) performDismiss: (NSTimer *)timer {
    [myAlert dismissWithClickedButtonIndex:0 animated:NO];//important
}

# pragma annotationsDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        //MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        //annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        //annotationView.pinColor = MAPinAnnotationColorGreen;
        annotationView.image = [UIImage imageNamed:@"租赁点12x18px"];
        return annotationView;
    }
    return nil;
}

#pragma searchTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.text = [districtArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Hello");
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
    //NSLog(@"Tap!");
    [searchTextField resignFirstResponder];
    myMapView.userTrackingMode = MAUserTrackingModeNone;
    indicatorButton.selected = NO;
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140"] forState:UIControlStateNormal];
    indicatorTag = 0;
    
    searchTextField.text = @"";
    tipsResultTableView.hidden = YES;
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"change!");
    self.myMapView.userTrackingMode = MAUserTrackingModeNone;
    indicatorButton.selected = NO;
    [indicatorButton setImage:[UIImage imageNamed:@"指南140x140"] forState:UIControlStateNormal];
    indicatorTag = 0;
    
    searchTextField.text = @"";
    tipsResultTableView.hidden = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //解决TableView和TextField与Touch产生冲突的问题
    //NSLog(@"%@",touch.view);
    if ([touch.view isKindOfClass:[UITextField class]] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } else {
        return YES;
    }
    //return NO;
}


//位置更新回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.myUserLocation = userLocation;
        
    }
}

 
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
        
        [self.myMapView updateUserLocationRepresentation:pre];
        
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
