//
//  collectionViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "collectionViewController.h"

@interface collectionViewController ()

@end

@implementation collectionViewController

@synthesize collectionView;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    self.navigationItem.title = @"绿出行圈";
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100) / 2, 10, 100, 30)];
    itemView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = itemView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"绿出行圈";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:titleLabel];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 114)];
    //self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    //NSLog(@"%f",self.tabBarController.tabBar.bounds.size.height);
    
    /*
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 3;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.collectionView.loadingView = loadingLabel;
    */
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf loadNewData];
    }];
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        // 下拉刷新
        [weakSelf loadMoreData];
    }];
    
    
    // 马上进入刷新状态
    //[self.collectionView.legendHeader beginRefreshing];
    
    itemsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 4; i ++) {
        [itemsArray addObject:[NSString stringWithFormat:@"trip%d.jpg",i]];
    }
    
    capitionArray = [[NSMutableArray alloc] initWithObjects:@"面朝大海，春暖花开",@"春天踏春，来一次说走就走的旅行.",@"放飞心情~" ,nil];
    
    [self.collectionView reloadData];
}

- (void)loadNewData {
    NSLog(@"refresh!");
    
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 3;
    
    [self.collectionView reloadData];
    
    [self.collectionView.legendHeader endRefreshing];   //结束刷新
    
}

- (void)loadMoreData {
    for (int i = 1; i < 4; i ++) {
        [itemsArray addObject:[NSString stringWithFormat:@"trip%d.jpg",i]];
    }
    [capitionArray addObject:@"面朝大海，春暖花开"];
    [capitionArray addObject:@"春天踏春，来一次说走就走的旅行."];
    [capitionArray addObject:@"放飞心情~"];
    [self.collectionView reloadData];
    
    [self.collectionView.legendFooter endRefreshing];
}

#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [itemsArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
        v.layer.cornerRadius = 3.0f;
        v.layer.masksToBounds = YES;
    }
    
    [v fillViewWithObject:[itemsArray objectAtIndex:index]];
    [v fillViewWithText:[capitionArray objectAtIndex:index]];
    
    return v;
    
    //return nil;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    
    //NSLog(@"self.collectionView.colWidth = %f".self.collectionView.colWidth.height);
    
    return [PSBroView heightForViewWithObject:[itemsArray objectAtIndex:index] withCapitionStr:[capitionArray objectAtIndex:index] inColumnWidth:self.collectionView.colWidth];
    
    //return 0.0;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    //    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You can do something when the user taps on a collectionViewCell here
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
