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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"绿出行圈";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.bounds.size.height)];
    [self.view addSubview:self.collectionView];
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 3;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.collectionView.loadingView = loadingLabel;
    
    itemsArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 11; i ++) {
        [itemsArray addObject:[NSString stringWithFormat:@"%d.jpeg",i]];
    }
    
    [self.collectionView reloadData];
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
        v.layer.cornerRadius = 5.0f;
        v.layer.masksToBounds = YES;
    }
    
    [v fillViewWithObject:[itemsArray objectAtIndex:index]];
    
    return v;
    
    //return nil;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    
    return [PSBroView heightForViewWithObject:[itemsArray objectAtIndex:index] inColumnWidth:self.collectionView.colWidth];
    
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
