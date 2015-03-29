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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Both fields are mandatory" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YDAPPNAME" accessGroup:nil];
        [keychain setObject:self.nameField.text forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:[self.passwordField.text MD5] forKey:(__bridge id)kSecValueData];
        //reading back a value from the keychain for comparison 
        //get username [keychain objectForKey:(__bridge id)kSecAttrAccount]);
        //get password [keychain objectForKey:(__bridge id)kSecValueData]);
        [YDConfigurationHelper setBoolValueForConfigurationKey:bYDRegistered withValue:YES];
    
        [self.delegate registeredWithSuccess];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelRegistration:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate cancelRegistration];
    //NSLog(@"cancel");
}
@end
