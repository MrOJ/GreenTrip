//
//  finishTripResultView.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/19.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface finishTripResultView : UIView

@property (nonatomic) NSInteger totalDistance;
@property (nonatomic) NSInteger busDistance;
@property (nonatomic) NSInteger bikeDistance;
@property (nonatomic) NSInteger walkingDistance;
@property (nonatomic) NSInteger transCount;

- (void)initSubViews;

@end
