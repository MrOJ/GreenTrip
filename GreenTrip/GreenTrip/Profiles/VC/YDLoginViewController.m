//
//  YDLoginViewController.m
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

#import "YDLoginViewController.h"
#import "YDLoginViewController.h"
#import "NSString+MD5.h"
#import "KeychainItemWrapper.h"
@interface YDLoginViewController ()

@end

@implementation YDLoginViewController
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

- (IBAction)loginUser:(UIButton *)sender
{
    if (([self.nameField.text length]== 0 ) || ([self.passwordField.text length] == 0))
    {
        [self showErrorWithMessage:@"输入不能为空!"];
    }
    else
    {
        /*
        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDAPPNAME" accessGroup:nil];
        if ([self.nameField.text isEqualToString:[keychain objectForKey:(__bridge id)kSecAttrAccount]])
        {
            if ([[self.passwordField.text MD5] isEqualToString:[keychain objectForKey:(__bridge id)kSecValueData]])
            {
                [self.delegate loginWithSuccess];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
                [self showErrorWithMessage:@"密码不正确."];
        }
        else
            [self showErrorWithMessage:@"用户名不正确."];
        */
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.nameField.text, @"password":[self.passwordField.text MD5] };
        
        //3.请求
        [manager GET:@"http://192.168.1.123:1200/login" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getLogin = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"login"]];
            
            if ([getLogin isEqualToString:@"0"]) {
                NSLog(@"登录成功！");
                [self.delegate loginWithSuccess];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ([getLogin isEqualToString:@"1"]) {
                self.passwordField.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"密码错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                self.nameField.text = @"";
                self.passwordField.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名不存在!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }

}

- (IBAction)cancelLogin:(UIButton *)sender
{
    [self.delegate loginCancelled];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
@end
