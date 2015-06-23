//
//  feedbackViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/6/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "YDConfigurationHelper.h"

@interface feedbackViewController : UIViewController<MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@end
