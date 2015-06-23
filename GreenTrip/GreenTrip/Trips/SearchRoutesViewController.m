//
//  SearchRoutesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "SearchRoutesViewController.h"
#import "YDConfigurationHelper.h"
#define TOEDGELEFT 60
#define MyKey "f57ba48c60c524724d3beff7f7063af9"
#define iosBlue [UIColor colorWithRed:28.0 / 255.0f green:98 / 255.0f blue:255.0 / 255.0f alpha:1.0f]
#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface SearchRoutesViewController ()

@end

@implementation SearchRoutesViewController

@synthesize busButton,walkButton,bikeButton,mixButton,ResultsTableView,startTextView,endTextView,SearchView;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:myColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    for (id object in self.navigationController.navigationBar.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            //NSLog(@"hello!!");
            [(UIButton *)object removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"绿色箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:myColor forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.tintColor = myColor;
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    getNameStr = [[NSString alloc] init];
    getAddr = [[NSString alloc] init];
    getLocation = [[NSString alloc] init];
    getTextTag = [[NSString alloc] init];
    
    getPattern = [[NSString alloc] init];
    
    startPoint = [[AMapGeoPoint alloc] init];
    endPoint   = [[AMapGeoPoint alloc] init];
    
    //设置下一个页面的返回键。
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    searchButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    [searchButton setTintColor:myColor];
    
    //测试的时候注释掉了,测试完记得加上！
    [searchButton setEnabled:NO];
    
    self.navigationItem.rightBarButtonItem = searchButton;

    busButton.selected = YES;   //默认选择当前界面
    [busButton setImage:[UIImage imageNamed:@"5-76x92"] forState:UIControlStateSelected];
    [busButton addTarget:self action:@selector(chooseBus:) forControlEvents:UIControlEventTouchUpInside];
    
    walkButton.selected = NO;
    [walkButton setImage:[UIImage imageNamed:@"4-54x92"] forState:UIControlStateSelected];
    [walkButton addTarget:self action:@selector(chooseWalk:) forControlEvents:UIControlEventTouchUpInside];
    
    bikeButton.selected = NO;
    [bikeButton setImage:[UIImage imageNamed:@"3-144x92"] forState:UIControlStateSelected];
    [bikeButton addTarget:self action:@selector(chooseBike:) forControlEvents:UIControlEventTouchUpInside];
    
    mixButton.selected = NO;
    [mixButton setImage:[UIImage imageNamed:@"6-100x98"] forState:UIControlStateSelected];
    [mixButton addTarget:self action:@selector(chooseMix:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [MAMapServices sharedServices].apiKey = @"f57ba48c60c524724d3beff7f7063af9";
    myMapView = [[MAMapView alloc] init];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    
    ResultsTableView.delegate = self;
    ResultsTableView.dataSource = self;
    ResultsTableView.hidden = YES;
    
    startTextView.delegate = self;
    startTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    startTextView.tag = 1;
    endTextView.delegate = self;
    endTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    endTextView.tag = 2;
    
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recNotification:) name:@"passValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recPattern:) name:@"passPattern" object:nil];
    
    //正在加载指示视图
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 200, self.view.bounds.size.width - 100 * 2, 80)];
    activityIndicatorView.backgroundColor = [UIColor darkGrayColor];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicatorView];
    
    wayFlag = 1;
    getPattern = @"0";

}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recNotification:(NSNotification *)notification {
    NSDictionary *getDic = [notification userInfo];
    getNameStr = [getDic objectForKey:@"name"];
    getLocation = [getDic objectForKey:@"location"];
    getAddr = [getDic objectForKey:@"address"];
    getTextTag = [getDic objectForKey:@"textTag"];
    
    if ([getTextTag isEqualToString:@"1"]) {
        startTextView.text = getNameStr;
        startPoint = (AMapGeoPoint *)getLocation;
    } else if ([getTextTag isEqualToString:@"2"]) {
        endTextView.text = getNameStr;
        endPoint = (AMapGeoPoint *)getLocation;
    }
    
    //NSLog(@"startPoint = %@",startPoint);
    //NSLog(@"endPoint = %@",endPoint);
    
    if (wayFlag == 1) {
        if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
            [searchButton setEnabled:YES];
            if ([startTextView.text isEqualToString:@"我的位置"]) {
                //收到数据后直接运行路径规划程序
                AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                [self navigationBusSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];;
            } else {
                [self navigationBusSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
                
                //NSLog(@"起点 = %@；终点 = %@",startPoint,endPoint);
                
            }
        } else {
            NSLog(@"输入不能为空");
            [searchButton setEnabled:NO];
        }
    } else if (wayFlag == 2) {
        if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
            [searchButton setEnabled:YES];
            if ([startTextView.text isEqualToString:@"我的位置"]) {
                //收到数据后直接运行路径规划程序
                AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                [self navigationWalkingSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
            } else {
                [self navigationWalkingSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
            }
        } else {
            NSLog(@"输入不能为空");
            [searchButton setEnabled:NO];
        }
    }  else if (wayFlag == 3) {
        if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
            [searchButton setEnabled:YES];
            
            //起点搜寻r米范围内的自行车租赁点
            //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
            AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
            poiRequest.searchType = AMapSearchType_PlaceAround;
            poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
            poiRequest.keywords = @"自行车租赁点";
            poiRequest.radius= 500;
            [search AMapPlaceSearch: poiRequest];
        } else {
            NSLog(@"输入不能为空");
            [searchButton setEnabled:NO];
        }
    } else {
        if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
            [searchButton setEnabled:YES];

            //起点搜寻r米范围内的自行车租赁点
            //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
            AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
            poiRequest.searchType = AMapSearchType_PlaceAround;
            poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
            poiRequest.keywords = @"自行车租赁点";
            poiRequest.radius= 500;
            [search AMapPlaceSearch: poiRequest];
        } else {
            NSLog(@"输入不能为空");
            [searchButton setEnabled:NO];
        }
    }

}

- (void)recPattern:(NSNotification *)notification {   //改变出行模式
    NSDictionary *getDic = [notification userInfo];
    getPattern = [getDic objectForKey:@"pattern"];
    //NSLog(@"get %@",getPattern);
    
    if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:YES];
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            [self navigationBusSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        } else {
            [self navigationBusSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        }
    } else {
        NSLog(@"输入不能为空");
        [searchButton setEnabled:NO];
    }
    
}

- (void)chooseBus:(id)sender {

    wayFlag = 1;
    
    if (![endTextView.text isEqualToString:@""]) {
        ResultsTableView.hidden = NO;
    }
    
    busButton.selected = YES;
    walkButton.selected = NO;
    bikeButton.selected = NO;
    mixButton.selected = NO;
    
    if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:YES];
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            [self navigationBusSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        } else {
            [self navigationBusSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        }
        //指示启动
        [activityIndicatorView startAnimating];//启动
    } else {
        NSLog(@"输入不能为空");
        [searchButton setEnabled:NO];
    }
    
}

- (void)chooseWalk:(id)sender {

    wayFlag = 2;
    
    ResultsTableView.hidden = YES;
    
    busButton.selected = NO;
    walkButton.selected = YES;
    bikeButton.selected = NO;
    mixButton.selected = NO;
    
    if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:YES];
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            [self navigationWalkingSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        } else {
            [self navigationWalkingSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
        }
        //指示启动
        [activityIndicatorView startAnimating];//启动
    } else {
        NSLog(@"输入不能为空");
        [searchButton setEnabled:NO];
    }
    
}

- (void)chooseBike:(id)sender {

    wayFlag = 3;
    ResultsTableView.hidden = YES;
    
    busButton.selected = NO;
    walkButton.selected = NO;
    bikeButton.selected = YES;
    mixButton.selected = NO;
    
    if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:YES];
        
        /*
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            [self pushShowBikeOnlyRoutesViewControllerStartPoint:start endPoint:endPoint];
        } else {
            [self pushShowBikeOnlyRoutesViewControllerStartPoint:startPoint endPoint:endPoint];
        }
        //指示启动
        //[activityIndicatorView startAnimating];//启动
        */
        
        //起点搜寻r米范围内的自行车租赁点
        //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceAround;
        poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
        poiRequest.keywords = @"自行车租赁点";
        poiRequest.radius= 500;
        [search AMapPlaceSearch: poiRequest];
        
    } else {
        NSLog(@"输入不能为空");
        [searchButton setEnabled:NO];
    }
    
}

- (void)chooseMix:(id)sender {

    wayFlag = 4;
    ResultsTableView.hidden = YES;
    
    busButton.selected = NO;
    walkButton.selected = NO;
    bikeButton.selected = NO;
    mixButton.selected = YES;
    
    if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:YES];
        /*
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            [self pushWithBikeTransViewControllerStartPonit:start endPoint:endPoint];
            
        } else {
            [self pushWithBikeTransViewControllerStartPonit:startPoint endPoint:endPoint];
        }
        //指示启动
        //[activityIndicatorView startAnimating];//启动
        */
        
        //起点搜寻r米范围内的自行车租赁点
        //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceAround;
        poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
        poiRequest.keywords = @"自行车租赁点";
        poiRequest.radius= 500;
        [search AMapPlaceSearch: poiRequest];
    } else {
        NSLog(@"输入不能为空");
        [searchButton setEnabled:NO];
    }
    
}

//点击搜索按钮实现响应
- (void)search:(id)sender {
    
    switch (wayFlag) {
        case 1: {
            //实际运行
            
            if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
                [searchButton setEnabled:YES];
                if ([startTextView.text isEqualToString:@"我的位置"]) {
                    //收到数据后直接运行路径规划程序
                    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                    [self navigationBusSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
                } else {
                    [self navigationBusSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
                }
                //指示启动
                [activityIndicatorView startAnimating];//启动
            } else {
                NSLog(@"输入不能为空");
                [searchButton setEnabled:NO];
            }
            
            //测试
            /*
            //构造AMapNavigationSearchRequest对象，配置查询参数
            AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
            naviRequest.searchType = AMapSearchType_NaviBus;
            //naviRequest.requireExtension = YES;
            naviRequest.origin = [AMapGeoPoint locationWithLatitude:30.223387 longitude:120.042572];
            naviRequest.destination = [AMapGeoPoint locationWithLatitude:30.270498 longitude:120.138268];
            naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
            //发起路径搜索
            [search AMapNavigationSearch: naviRequest];
            */
        }
            break;
        
        case 2: {

            if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
                [searchButton setEnabled:YES];
                if ([startTextView.text isEqualToString:@"我的位置"]) {
                    //收到数据后直接运行路径规划程序
                    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                    [self navigationWalkingSearchStartLacation:start getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
                } else {
                    [self navigationWalkingSearchStartLacation:startPoint getLocation:endPoint chooseStategy:[getPattern integerValue] city:[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]];
                }
                //指示启动
                [activityIndicatorView startAnimating];//启动
            } else {
                NSLog(@"输入不能为空");
                [searchButton setEnabled:NO];
            }
            
            /*
            //测试
            //构造AMapNavigationSearchRequest对象，配置查询参数
            AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
            naviRequest.searchType = AMapSearchType_NaviWalking;
            //naviRequest.requireExtension = YES;
            naviRequest.origin = [AMapGeoPoint locationWithLatitude:30.223387 longitude:120.042572];
            naviRequest.destination = [AMapGeoPoint locationWithLatitude:30.270498 longitude:120.138268];
            naviRequest.city = [YDConfigurationHelper getStringValueForConfigurationKey:@"city"];
            //发起路径搜索
            [search AMapNavigationSearch: naviRequest];
            */
        }
            break;
            
        
        case 3: {
            if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
                [searchButton setEnabled:YES];
                
                /*
                if ([startTextView.text isEqualToString:@"我的位置"]) {
                    //收到数据后直接运行路径规划程序
                    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                    [self pushShowBikeOnlyRoutesViewControllerStartPoint:start endPoint:endPoint];
                } else {
                    [self pushShowBikeOnlyRoutesViewControllerStartPoint:startPoint endPoint:endPoint];
                }
                //指示启动
                //[activityIndicatorView startAnimating];//启动
                */
                
                //起点搜寻r米范围内的自行车租赁点
                //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
                AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
                poiRequest.searchType = AMapSearchType_PlaceAround;
                poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
                poiRequest.keywords = @"自行车租赁点";
                poiRequest.radius= 500;
                [search AMapPlaceSearch: poiRequest];
                
            } else {
                NSLog(@"输入不能为空");
                [searchButton setEnabled:NO];
            }
            
            //测试
            //[self pushShowBikeOnlyRoutesViewControllerStartPoint:[AMapGeoPoint locationWithLatitude:30.223387 longitude:120.042572] endPoint:[AMapGeoPoint locationWithLatitude:30.270498 longitude:120.138268]];
            
        }
            break;
        
        case 4: {
            
            if (![startTextView.text isEqualToString:@""] && ![endTextView.text isEqualToString:@""]) {
                [searchButton setEnabled:YES];
                
                /*
                if ([startTextView.text isEqualToString:@"我的位置"]) {
                    //收到数据后直接运行路径规划程序
                    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
                    [self pushWithBikeTransViewControllerStartPonit:start endPoint:endPoint];
                    
                } else {
                    [self pushWithBikeTransViewControllerStartPonit:startPoint endPoint:endPoint];
                }
                //指示启动
                //[activityIndicatorView startAnimating];//启动
                */
                //起点搜寻r米范围内的自行车租赁点
                //由于不能直接继续push视图，因此在这里设置一定的延迟在推入，如果直接点搜索则问题不大
                AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
                poiRequest.searchType = AMapSearchType_PlaceAround;
                poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
                poiRequest.keywords = @"自行车租赁点";
                poiRequest.radius= 500;
                [search AMapPlaceSearch: poiRequest];
            } else {
                NSLog(@"输入不能为空");
                [searchButton setEnabled:NO];
            }
            
            //[self pushWithBikeTransViewControllerStartPonit:[AMapGeoPoint locationWithLatitude:30.254080 longitude:120.062393] endPoint:[AMapGeoPoint locationWithLatitude:30.305847 longitude:120.146019]];
            /*
            //起点搜寻r米范围内的自行车租赁点
            AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
            poiRequest.searchType = AMapSearchType_PlaceAround;
            poiRequest.location = startPoint;//固定的站点，难怪不会实时动态更新
            poiRequest.keywords = @"自行车租赁点";
            poiRequest.radius= 500;
            [search AMapPlaceSearch: poiRequest];
            */
        }
            break;
        
        default:
            break;
    }
    
}

- (IBAction)reverseButton:(id)sender
{
    NSString *temStr = startTextView.text;
    startTextView.text = endTextView.text;
    endTextView.text = temStr;
    
    AMapGeoPoint *tempPoint = [[AMapGeoPoint alloc] init];
    tempPoint = startPoint;
    startPoint = endPoint;
    endPoint = startPoint;
}

/*
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSLog(@"12345");
    NSLog(@"bicycleName = %@", withBikeResults.bicyclePOI);
}
*/

//实现键盘响应
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textFieldEditDetailsViewController *textFieldEditView = [[textFieldEditDetailsViewController alloc] init];
    textFieldEditView.textTag = textField.tag;
    [self.navigationController pushViewController:textFieldEditView animated:NO];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    if (response.count > 0) {
        if ([startTextView.text isEqualToString:@"我的位置"]) {
            //收到数据后直接运行路径规划程序
            AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:userLatitude longitude:userLongtitude];;
            
            if (wayFlag == 4) {
                [self pushWithBikeTransViewControllerStartPonit:start endPoint:endPoint];
            } else if (wayFlag == 3) {
                [self pushShowBikeOnlyRoutesViewControllerStartPoint:start endPoint:endPoint];
            }
            
            
        } else {
            if (wayFlag == 4) {
                [self pushWithBikeTransViewControllerStartPonit:startPoint endPoint:endPoint];
            } else if (wayFlag == 3) {
                [self pushShowBikeOnlyRoutesViewControllerStartPoint:startPoint endPoint:endPoint];
                
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查找失败" message:@"附近未找到自行车站点，请换用其他换乘策略" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


//实现路径搜索的回调函数
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    switch (wayFlag) {
        case 1: {
            [self processBusResultData:response];
            [activityIndicatorView stopAnimating];//停止
            ResultsTableView.hidden = NO;
        }
            break;
            
        case 2: {
            //NSLog(@"%@",response.route);
            if (response.route.paths != nil) {
                showRoutesDetailsViewController *showRouteDeVC = [[showRoutesDetailsViewController alloc] init];
                showRouteDeVC.wayFlag = wayFlag;
                showRouteDeVC.startName = startTextView.text;
                showRouteDeVC.endName = endTextView.text;
                showRouteDeVC.allRoutes = response.route;
                
                [self.navigationController pushViewController:showRouteDeVC animated:YES];
                
                [activityIndicatorView stopAnimating];//停止
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未找到" message:@"未找到步行线路！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
            
        case 3: {
            if (response.route.paths != nil) {
                showRoutesDetailsViewController *showRouteDeVC = [[showRoutesDetailsViewController alloc] init];
                showRouteDeVC.wayFlag = wayFlag;
                showRouteDeVC.startName = startTextView.text;
                showRouteDeVC.endName = endTextView.text;
                showRouteDeVC.allRoutes = response.route;
                
                [self.navigationController pushViewController:showRouteDeVC animated:YES];
                [activityIndicatorView stopAnimating];//停止

            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未找到" message:@"未找到步行线路！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
            
        case 4: {
            
        }
            break;
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//自定义section
- (UIView *) tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section
{
    //UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView1.bounds.size.width, 220)];
    //[sectionView setBackgroundColor:[UIColor blackColor]];
    UIButton *buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    [buttonView addTarget:self action:@selector(choosePrefer:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableViewCell *sectionCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    sectionCell.backgroundColor = [UIColor whiteColor];
    sectionCell.alpha = 0.8f;
    sectionCell.textLabel.text = @"偏好选择";
    sectionCell.textLabel.textColor = myColor;
    //sectionCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 20 - 9, 14, 9, 17)];
    arrowImgView.image = [UIImage imageNamed:@"偏好箭头36x68px"];
    [sectionCell addSubview:arrowImgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = myColor;
    [sectionCell addSubview:lineView];
    
    //[buttonView addSubview:sectionCell];
    [sectionCell addSubview:buttonView];
    
    
    //return buttonView;
    return sectionCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%ld",(long)transCount);
    return transCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //本函数用于显示每行的内容
    static NSString *MyIdentifier = @"MyIdentifier"; // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier]; // If no cell is available, create a new one using the given identifier.
    if (cell == nil)
    {
        // Use the default cell style.
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    // Set up the cell.
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [buslineArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    
    NSString *duration = [[NSString alloc] initWithString:[durationArray objectAtIndex:indexPath.row]];
    NSString *totalDis = [[NSString alloc] initWithString:[totalDisArray objectAtIndex:indexPath.row]];
    NSString *walkDis  = [[NSString alloc] initWithString:[walkDisArray objectAtIndex:indexPath.row]];
    
    NSString *detailText = [[NSString alloc] initWithFormat:@"%@ | %@ | %@", duration ,totalDis ,walkDis];
    cell.detailTextLabel.text= detailText;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 20 - 9, 24, 9, 17)];
    arrowImgView.image = [UIImage imageNamed:@"路线选择箭头36x68px"];
    [cell addSubview:arrowImgView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"walkArray = %@",[walkStepArray objectAtIndex:indexPath.row]);
    NSInteger row = indexPath.row;
    
    //必须先执行addObserver!!建立响应者,再发布通知post,所以进行notification传至不适用于pushview的情况（因为后面的一页的响应是之后建立的）.nitification比较适合后面一页传到前面的一页！！
    //解决方法是在B里面声明一个属性，在A里面创建B的时候，将B的属性赋值即可。简单实用！
    
    showRoutesDetailsViewController *routesDetailsVC = [[showRoutesDetailsViewController alloc] init];
    routesDetailsVC.index = row;
    routesDetailsVC.allRoutes = getRoute;
    routesDetailsVC.buslineArray = buslineArray;
    routesDetailsVC.totalDisArray = totalDisArray;
    routesDetailsVC.walkDisArray = walkDisArray;
    routesDetailsVC.durationArray = durationArray;
    routesDetailsVC.wayFlag = wayFlag;
    
    routesDetailsVC.startName = startTextView.text;           //需要修改
    routesDetailsVC.endName = endTextView.text;
    //routesDetailsVC.startName = @"我的位置";
    //routesDetailsVC.endName = @"目标位置（待改）";
    
    [self.navigationController pushViewController:routesDetailsVC animated:YES];
    
}


//获取用户当前位置
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        userLatitude = userLocation.coordinate.latitude;
        userLongtitude = userLocation.coordinate.longitude;
        myMapView.showsUserLocation = NO;
    }
}

- (void)choosePrefer:(id)sender {
    //NSLog(@"choosePrefer");
    choosePreferViewController *chooserPreferVC = [[choosePreferViewController alloc] init];
    [self.navigationController pushViewController:chooserPreferVC animated:YES];
}

- (void)pushShowBikeOnlyRoutesViewControllerStartPoint:(AMapGeoPoint *)start endPoint:(AMapGeoPoint *)end
{
    showBikeOnlyRoutesViewController *showBikeOnlyRoutesVC = [[showBikeOnlyRoutesViewController alloc] init];
    
    showBikeOnlyRoutesVC.startPoint = start;
    showBikeOnlyRoutesVC.endPoint   = end;
    showBikeOnlyRoutesVC.startName  = startTextView.text;
    showBikeOnlyRoutesVC.endName    = endTextView.text;
    showBikeOnlyRoutesVC.navigationItem.title = @"自行车路线";
    
    [self.navigationController pushViewController:showBikeOnlyRoutesVC animated:NO];
    
    //[activityIndicatorView stopAnimating];
}

- (void)pushWithBikeTransViewControllerStartPonit:(AMapGeoPoint *)start endPoint:(AMapGeoPoint *)end
{
    withBikeTransViewController *withBikeTransVC = [[withBikeTransViewController alloc] init];
    withBikeTransVC.startPoint = start;
    withBikeTransVC.endPoint   = end;
    withBikeTransVC.startName  = startTextView.text;
    withBikeTransVC.endName    = endTextView.text;
    withBikeTransVC.navigationItem.title = @"混合模式换乘结果";
    
    [self.navigationController pushViewController:withBikeTransVC animated:NO];
    
    //[activityIndicatorView stopAnimating];

}

//执行公交路线搜索函数
- (void)navigationBusSearchStartLacation:(AMapGeoPoint *)startLocation getLocation:(AMapGeoPoint *)endLocation chooseStategy:(NSInteger)strategy city:(NSString *)city
{
    if ([startTextView.text isEqualToString:@""] || [endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:NO];
        NSLog(@"输入不能为空！");
    } else {
        //NSLog(@"userlatitude : %f,userlongitude: %f",userLatitude,userLongtitude);
        [searchButton setEnabled:YES];
        
        //构造AMapNavigationSearchRequest对象，配置查询参数
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = AMapSearchType_NaviBus;
        naviRequest.requireExtension = YES;
        naviRequest.strategy = strategy;
        naviRequest.origin = startLocation;
        naviRequest.destination = endLocation;
        naviRequest.city = city;
        
        //发起路径搜索
        [search AMapNavigationSearch: naviRequest];
        
        //加载指示启动
        [activityIndicatorView startAnimating];//启动
        ResultsTableView.hidden = YES;
        
    }
    
    
}

//执行步行路线搜索函数
- (void)navigationWalkingSearchStartLacation:(AMapGeoPoint *)startLocation getLocation:(AMapGeoPoint *)endLocation chooseStategy:(NSInteger)strategy city:(NSString *)city
{
    if ([startTextView.text isEqualToString:@""] || [endTextView.text isEqualToString:@""]) {
        [searchButton setEnabled:NO];
        NSLog(@"输入不能为空！");
    } else {
        //NSLog(@"userlatitude : %f,userlongitude: %f",userLatitude,userLongtitude);
        [searchButton setEnabled:YES];
        
        //构造AMapNavigationSearchRequest对象，配置查询参数
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = AMapSearchType_NaviWalking;
        naviRequest.requireExtension = YES;
        //naviRequest.strategy = strategy;
        naviRequest.origin = startLocation;
        naviRequest.destination = endLocation;
        naviRequest.city = city;
        
        //发起路径搜索
        [search AMapNavigationSearch: naviRequest];
        
        //加载指示启动
        //[activityIndicatorView startAnimating];//启动
        //ResultsTableView.hidden = YES;
        
    }
}

//处理公交数据函数
- (void)processBusResultData:(AMapNavigationSearchResponse *)response
{
    buslineArray = [[NSMutableArray alloc] init];
    totalDisArray = [[NSMutableArray alloc] init];
    walkDisArray = [[NSMutableArray alloc] init];
    durationArray = [[NSMutableArray alloc] init];
    walkStepArray = [[NSMutableArray alloc] init];
    busStopArray = [[NSMutableArray alloc] init];
    //priceArray = [[NSMutableArray alloc] init];
    
    NSString *busName = [[NSString alloc] init];
    
    transCount = response.route.transits.count;
    
    getRoute = response.route;
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    //数据结构：每个 AMapsegment 都包含AMapWaklking和AMapBusline，最后一个步骤为只有步行而没有公交车，busline为null
    //NSString *transits = [NSString stringWithFormat:@"Navi: %@", response.route.transits];
    //NSLog(@"transits count = %lu", (unsigned long)response.route.transits.count);
    //NSLog(@"%@", transits);
    
    // -- * 处理公交线路名称 * --
    for (AMapTransit *t in response.route.transits) {
        
        if (t.segments.count <= 2) {             //不需要换乘
            for (AMapSegment *s in t.segments) {
                
                if (s.busline != nil) {
                    busName = [self busNameTrans:s.busline.name];
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
                        busName = [busName stringByAppendingString:[NSString stringWithFormat:@"→%@",tmpStr]];
                    } else {
                        busName = tmpStr;
                    }
                    i++;
                }
            }
        }
        //NSLog(@"busName = %@",busName);
        [buslineArray addObject:busName];
        
        // -- * 处理公线路距离 * --
        NSInteger totalDistance = 0;       //单位：米
        NSInteger walkDistance = 0;        //单位：米
        for (AMapSegment *s in t.segments) {
            NSInteger walkDis = s.walking.distance;
            NSInteger busDis = s.busline.distance;
            totalDistance += walkDis + busDis;
            walkDistance += walkDis;
        }
        [totalDisArray addObject:[NSString stringWithFormat:@"%.1f公里", (float)totalDistance / 1000]];
        if (walkDistance < 1000) {
            [walkDisArray addObject:[NSString stringWithFormat:@"%ld米", (long)walkDistance]];
        } else {
            [walkDisArray addObject:[NSString stringWithFormat:@"%.1f公里", (float)walkDistance / 1000]];
        }
        //NSLog(@"总距离：%.1f公里", (float)totalDistance / 1000);
        //NSLog(@"步行：%ld米", (long)walkDistance);
        
        // -- * 处理总时间 * --
        NSInteger duration = 0;            //单位：秒
        for (AMapSegment *s in t.segments) {
            NSInteger walkDura = s.walking.duration;
            NSInteger busDura = s.busline.duration;
            duration += walkDura + busDura;
        }
        [durationArray addObject:[self timeFormatted:duration]];
        //NSLog(@"duration =  %@",[self timeFormatted:duration]);
        
        
        // -- * 处理路线经纬度 * --
        NSMutableArray *walkStep = [[NSMutableArray alloc] init];
        NSMutableArray *busStop = [[NSMutableArray alloc] init];
        for (AMapSegment *s in t.segments) {
            
            if (s.walking != nil) {
                [walkStep addObject:s.walking];       //步行路段数组，数组中存放 AMapWalking 对象。
            }
            if (s.busline != nil) {
                [busStop addObject:s.busline];     //途经公交站数组，数组中存放 AMapBusLine 对象。
            }
        }
        
        //NSLog(@"walkStepArray = %@",walkStepArray);
        [walkStepArray addObject:walkStep];
        [busStopArray addObject:busStop];
        
    }
    
    ResultsTableView.hidden = NO;
    [ResultsTableView reloadData];
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

//时间转换
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    //NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours < 1) {
        return [NSString stringWithFormat:@"%ld分钟", (long)minutes];
    } else {
        return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hours, (long)minutes];
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
