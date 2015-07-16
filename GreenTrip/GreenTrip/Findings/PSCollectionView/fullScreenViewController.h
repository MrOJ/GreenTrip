//
//  fullScreenViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/7/16.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FullScreenView.h"

@interface fullScreenViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)FullScreenView *fullScreen;

@end
