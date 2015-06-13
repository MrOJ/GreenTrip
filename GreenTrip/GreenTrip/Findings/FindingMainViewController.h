//
//  FindingMainViewController.h
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionViewController.h"
#import "MBProgressHUD.h"

@interface FindingMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    NSArray *titleArray;
    
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITableView *findingTableViewController;

@end
