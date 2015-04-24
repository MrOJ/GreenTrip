//
//  profilesViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/4/24.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "KeychainItemWrapper.h"
#import "YDConfigurationHelper.h"

@interface profilesViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *LoginView;
@property (strong, nonatomic) IBOutlet UIView *afterLoginView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)login:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)useQQ:(id)sender;
- (IBAction)useWeChat:(id)sender;
- (IBAction)useWeibo:(id)sender;

@end
