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
#import "SettingMainViewController.h"

@interface profilesViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *LoginView;
@property (strong, nonatomic) IBOutlet UIView *afterLoginView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;



@property (strong, nonatomic) IBOutlet UIButton *portraitButton;        //头像
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;   //资料背景
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;         //昵称
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;          //状态

@property (strong, nonatomic) IBOutlet UILabel *takingbusNumLabel;     //累计乘坐公交
@property (strong, nonatomic) IBOutlet UILabel *takingbikeNumLabel;    //累计骑行
@property (strong, nonatomic) IBOutlet UILabel *reducingLabel;         //累计减排

@property (strong, nonatomic) IBOutlet UILabel *percentLabel;          //打败全国

- (IBAction)login:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)useQQ:(id)sender;
- (IBAction)useWeChat:(id)sender;
- (IBAction)useWeibo:(id)sender;

- (IBAction)uploadPortrait:(id)sender;

@end
