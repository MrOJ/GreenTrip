//
//  sendMessagesViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/25.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDConfigurationHelper.h"

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface sendMessagesViewController : UIViewController
{
    UITextView *msgTextView;
}

@property (nonatomic, strong)UIImage *image;

@end
