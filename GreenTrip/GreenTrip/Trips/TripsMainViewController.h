//
//  TripsMainViewController.h
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"
#import "CustomAnnotationView.h"

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface TripsMainViewController : UIViewController <MAMapViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate>
{
    UIView *testView;
    //NSInteger indicatorTag;
    NSString *textStr;
    AMapSearchAPI *search;
    
    NSMutableArray *nameArray;
    NSMutableArray *districtArray;
    
    UIAlertView *myAlert;
    
    int buttonFlag;

}

@property (strong, nonatomic) MAMapView *myMapView;
@property (retain, nonatomic) IBOutlet UIView *_mapView;

@property (strong, nonatomic) IBOutlet UIView *scalingView;
@property (strong, nonatomic) IBOutlet UIButton *indicatorButton;

@property (strong, nonatomic) IBOutlet UIButton *increaseButton;
@property (strong, nonatomic) IBOutlet UIButton *decreaseButton;
@property (strong, nonatomic) UIView *titleV;

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIView *searchIconView;
@property (strong, nonatomic) IBOutlet UIButton *bikeSearchButton;

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic) NSInteger indicatorTag;

@property (strong, nonatomic) UITableView *tipsResultTableView;

@property (strong, nonatomic) MAUserLocation *myUserLocation;;

@property (strong, nonatomic) NSMutableArray *POIsArray;

@property (strong, nonatomic) UIButton *busButton;
@property (strong, nonatomic) UIButton *bikePlaceButton;

- (IBAction)getIndicator:(id)sender;
- (IBAction)increaseScaling:(id)sender;
- (IBAction)decreaseScaling:(id)sender;

- (IBAction)bikePointSearch:(id)sender;
@end
