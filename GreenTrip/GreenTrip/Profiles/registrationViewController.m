//
//  registrationViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/4/29.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "registrationViewController.h"
#import "NSString+MD5.h"
#import "KeychainItemWrapper.h"

@interface registrationViewController ()

@end

@implementation registrationViewController

@synthesize usernameTextField,passwordTextField,enterButton,chooseButton,protocolButton;
@synthesize myAlert;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    for (id object in self.navigationController.navigationBar.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            //NSLog(@"hello!!");
            [(UIButton *)object removeFromSuperview];
        }
    }
    
    //设置返回按钮 将原先的bar隐藏起来
    UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] init];
    nilButton.title = @"";
    self.navigationItem.leftBarButtonItem = nilButton;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
    [backButton setImage:[UIImage imageNamed:@"箭头9x17px"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    */
    
    self.navigationItem.title = @"注册";
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enter:(id)sender {
    if (([self.usernameTextField.text length]== 0 ) || ([self.passwordTextField.text length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([self.passwordTextField.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"密码长度不得小于6，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.passwordTextField becomeFirstResponder];
    } else {
        
        //上传至服务器
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.usernameTextField.text,
                                @"password":[self.passwordTextField.text MD5],
                                @"sex":@"男",
                                @"device":@"iOS",
                                @"city":[YDConfigurationHelper getStringValueForConfigurationKey:@"city"]};
                                //};
        
        //3.请求
        [manager GET:@"http://121.40.218.33:1200/register" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getRegister = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"register"]];
            if ([getRegister isEqualToString:@"0"]) {
                NSLog(@"注册成功.");
                KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDAPPNAME" accessGroup:nil];
                [keychain setObject:self.usernameTextField.text forKey:(__bridge id)kSecAttrAccount];
                [keychain setObject:[self.passwordTextField.text MD5] forKey:(__bridge id)kSecValueData];
                //reading back a value from the keychain for comparison
                //get username [keychain objectForKey:(__bridge id)kSecAttrAccount]);
                //get password [keychain objectForKey:(__bridge id)kSecValueData]);
                
                [YDConfigurationHelper setBoolValueForConfigurationKey:bYDRegistered withValue:YES];
                [YDConfigurationHelper setStringValueForConfigurationKey:self.usernameTextField.text withValue:@"username"];
                [YDConfigurationHelper setStringValueForConfigurationKey:@"男" withValue:@"sex"];
                
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.delegate = self;
                HUD.labelText = @"注册成功";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];

            } else {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已经存在！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)protocol:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
