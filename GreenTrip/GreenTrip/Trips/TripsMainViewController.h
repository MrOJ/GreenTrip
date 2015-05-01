//
//  TripsMainViewController.h
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface TripsMainViewController : UIViewController <MAMapViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *testView;
    NSInteger indicatorTag;
}

@property (strong, nonatomic) MAMapView *mapView;
@property (retain, nonatomic) IBOutlet UIView *_mapView;

@property (strong, nonatomic) IBOutlet UIView *scalingView;
@property (strong, nonatomic) IBOutlet UIButton *indicatorButton;

@property (strong, nonatomic) IBOutlet UIButton *increaseButton;
@property (strong, nonatomic) IBOutlet UIButton *decreaseButton;
@property (strong, nonatomic) UIView *titleV;

@property (strong, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)getIndicator:(id)sender;
- (IBAction)increaseScaling:(id)sender;
- (IBAction)decreaseScaling:(id)sender;
@end
