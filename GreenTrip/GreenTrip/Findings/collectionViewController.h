//
//  collectionViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PSBroView.h"
#import "MJRefresh.h"

@interface collectionViewController : UIViewController <PSCollectionViewDelegate, PSCollectionViewDataSource>
{
    NSMutableArray *itemsArray;
}

@property (nonatomic, strong) PSCollectionView *collectionView;

@end
