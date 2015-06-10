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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    self.navigationItem.title = @"注册";
    
    myAlert = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enter:(id)sender {
    if (([self.usernameTextField.text length]== 0 ) || ([self.passwordTextField.text length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        //上传至服务器
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.usernameTextField.text, @"password":[self.passwordTextField.text MD5]};
        
        //3.请求
        [manager GET:@"http://192.168.1.123:1200/register" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getRegister = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"register"]];
            if ([getRegister isEqualToString:@"0"]) {
                NSLog(@"注册成功.");
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector: @selector(performDismiss:)  userInfo:nil repeats:NO];
                [myAlert show];
                
                KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDAPPNAME" accessGroup:nil];
                [keychain setObject:self.usernameTextField.text forKey:(__bridge id)kSecAttrAccount];
                [keychain setObject:[self.passwordTextField.text MD5] forKey:(__bridge id)kSecValueData];
                //reading back a value from the keychain for comparison
                //get username [keychain objectForKey:(__bridge id)kSecAttrAccount]);
                //get password [keychain objectForKey:(__bridge id)kSecValueData]);
                
                [YDConfigurationHelper setBoolValueForConfigurationKey:bYDRegistered withValue:YES];
                [YDConfigurationHelper setStringValueForConfigurationKey:self.usernameTextField.text withValue:@"username"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已经存在！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }

}

- (IBAction)protocol:(id)sender {
    
}

- (void) performDismiss: (NSTimer *)timer {
    [myAlert dismissWithClickedButtonIndex:0 animated:NO];//important
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
