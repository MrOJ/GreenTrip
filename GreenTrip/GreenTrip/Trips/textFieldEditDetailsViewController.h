//
//  textFieldEditDetailsViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/19.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "SearchRoutesViewController.h"
#import "customActionSheet.h"

@interface textFieldEditDetailsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
{
    UIBarButtonItem *enterButton;
    UITextField *editText;
    UITableView *tipsResultTableView;
    UITableView *confirmTableView;
    //UITableViewCell *cell;
    //unsigned long len;
    NSString *textStr;
    
    AMapSearchAPI *search;
    
    NSMutableArray *nameArray;
    NSMutableArray *districtArray;
    
    NSMutableArray *addrArray;
    NSMutableArray *locArray;
    
    UITapGestureRecognizer *_tapGr;
    
    NSInteger row;
    
    customActionSheet *sheet;
    
}

@property (nonatomic)NSInteger textTag;

@end
