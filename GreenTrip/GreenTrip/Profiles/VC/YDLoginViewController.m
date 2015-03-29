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
