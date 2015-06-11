//
//  updateProfilesViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/6/11.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDConfigurationHelper.h"
#import "AFNetworking.h"

#import "MBProgressHUD.h"

@interface updateProfilesViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MBProgressHUDDelegate>
{
    UITextField *nicknameTextField;
    UITextField *signatureTextField;
    UITextField *sexTextField;
    UITextField *birthdayTextField;
    UITextField *emailTextField;
    UITextField *phoneTextField;
    
    UIAlertView *myAlert;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, strong)UIDatePicker *datePick;
@property (nonatomic, strong)UIPickerView *sexPicker;

@end
