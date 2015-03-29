//
//  loginViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/27.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDLoginViewController.h"
#import "YDRegistrationViewController.h"

@interface loginViewController : UIViewController<YDLoginViewControllerDelegate,YDRegistrationViewControllerDelegate>
{
    NSString *getStr;
}

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) YDLoginViewController *loginVC;
@property (strong, nonatomic) YDRegistrationViewController *registrationVC;

@property (strong, nonatomic) IBOutlet UIView *LoginningView;
@property (strong, nonatomic) IBOutlet UIView *afterLoginView;
- (IBAction)getLogin:(id)sender;
- (IBAction)getRegister:(id)sender;

@end
