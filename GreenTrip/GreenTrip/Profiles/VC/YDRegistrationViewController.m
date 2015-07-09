//
//  YDRegistrationViewController.m
//  MyPersonalLibrary
//  This file is part of source code lessons that are related to the book
//  Title: Professional IOS Programming
//  Publisher: John Wiley & Sons Inc
//  ISBN 978-1-118-66113-0
//  Author: Peter van de Put
//  Company: YourDeveloper Mobile Solutions
//  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
//  Copyright (c) 2013 with the author and publisher. All rights reserved.
//

#import "YDRegistrationViewController.h"
#import "NSString+MD5.h"
#import "KeychainItemWrapper.h"
@interface YDRegistrationViewController ()

@end

@implementation YDRegistrationViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(UIButton *)sender
{
    if (([self.nameField.text length]== 0 ) || ([self.passwordField.text length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
     
        //上传至服务器
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.nameField.text, @"password":[self.passwordField.text MD5]};
        
        //3.请求
        [manager GET:@"http://192.168.1.104:1200/register" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getRegister = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"register"]];
            if ([getRegister isEqualToString:@"0"]) {
                NSLog(@"注册成功.");
                KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDAPPNAME" accessGroup:nil];
                [keychain setObject:self.nameField.text forKey:(__bridge id)kSecAttrAccount];
                [keychain setObject:[self.passwordField.text MD5] forKey:(__bridge id)kSecValueData];
                //reading back a value from the keychain for comparison
                //get username [keychain objectForKey:(__bridge id)kSecAttrAccount]);
                //get password [keychain objectForKey:(__bridge id)kSecValueData]);
                [YDConfigurationHelper setBoolValueForConfigurationKey:bYDRegistered withValue:YES];
                
                [self.delegate registeredWithSuccess];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已经存在！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
}

- (IBAction)cancelRegistration:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate cancelRegistration];
    //NSLog(@"cancel");
}
@end
