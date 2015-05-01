//
//  registrationViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/4/29.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDConfigurationHelper.h"
#import "AFNetworking.h"

@interface registrationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *enterButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseButton;
@property (strong, nonatomic) IBOutlet UIButton *protocolButton;

@property (nonatomic, strong) UIAlertView *myAlert;

- (IBAction)enter:(id)sender;
- (IBAction)protocol:(id)sender;
@end
