//
//  FindingMainViewController.h
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionViewController.h"

@interface FindingMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArray;
}

@property (strong, nonatomic) IBOutlet UITableView *findingTableViewController;

@end
