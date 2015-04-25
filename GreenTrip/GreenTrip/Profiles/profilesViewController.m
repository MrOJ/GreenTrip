//
//  profilesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/4/24.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "profilesViewController.h"

@interface profilesViewController ()

@end

@implementation profilesViewController

@synthesize usernameTextField,passwordTextField,LoginView,afterLoginView;
@synthesize portraitButton,backgroundImageView,nicknameLabel,messageLabel;
@synthesize takingbikeNumLabel,takingbusNumLabel,reducingLabel,percentLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    if ([YDConfigurationHelper getBoolValueForConfigurationKey:@"isLogout"]) {
        //NSLog(@"Yes!");
        LoginView.hidden = NO;
        afterLoginView.hidden = YES;
        
        self.navigationItem.title = @"登录帐号";
        
        UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goRegister:)];
        self.navigationItem.rightBarButtonItem = registerButton;
        
    } else {
        if (!bYDRegistrationRequired || [YDConfigurationHelper getBoolValueForConfigurationKey:bYDRegistered])
        {
            // you arrive here if either the registration is not required or yet achieved
            if (!bYDLoginRequired)
            {
                LoginView.hidden = YES;
                afterLoginView.hidden = NO;
                
                self.navigationItem.title = @"个人资料";
                
                UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"4设置130x80"] style:UIBarButtonItemStylePlain target:self action:@selector(goSetting:)];
                self.navigationItem.rightBarButtonItem = settingButton;
                
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //实际这个地方要删去
    [YDConfigurationHelper setBoolValueForConfigurationKey:@"isLogout" withValue:NO];

}

//进入注册界面
- (void)goRegister:(id)sender {
    
}

//进入设置界面
- (void)goSetting:(id)sender {
    SettingMainViewController *settingMainVC = [[SettingMainViewController alloc] init];
    
    [self.navigationController pushViewController:settingMainVC animated:YES];
}

- (IBAction)login:(id)sender {
    if (([self.usernameTextField.text length]== 0 ) || ([self.passwordTextField.text length] == 0))
    {
        [self showErrorWithMessage:@"输入不能为空"];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.usernameTextField.text, @"password":[self.passwordTextField.text MD5] };
        
        //3.请求
        [manager GET:@"http://localhost:1200/login" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getLogin = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"login"]];
            
            if ([getLogin isEqualToString:@"0"]) {
                NSLog(@"登录成功！");
                [YDConfigurationHelper setBoolValueForConfigurationKey:@"isLogout" withValue:NO];
                LoginView.hidden = YES;
                afterLoginView.hidden = NO;
                //[self.delegate loginWithSuccess];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ([getLogin isEqualToString:@"1"]) {
                self.passwordTextField.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"密码错误，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                self.usernameTextField.text = @"";
                self.passwordTextField.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名不存在，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorWithMessage:@"连接失败，请检测网络"];
        }];
    }
}

- (IBAction)forgetPassword:(id)sender {
    
}

- (IBAction)useQQ:(id)sender {
    
}

- (IBAction)useWeChat:(id)sender {
    
}

- (IBAction)useWeibo:(id)sender {
    
}

- (IBAction)uploadPortrait:(id)sender {
    NSLog(@"上传头像");
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        
        [self.view endEditing:YES];
        
    }
    
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
