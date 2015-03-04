//
//  choosePreferViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/24.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface choosePreferViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *choosePreferTV;
    
    NSArray *preferArray;
}

@end
