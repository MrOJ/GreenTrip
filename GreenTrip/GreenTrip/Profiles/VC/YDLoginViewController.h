//
//  YDLoginViewController.h
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

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@protocol YDLoginViewControllerDelegate <NSObject>

-(void)loginWithSuccess;
-(void)loginWithError;
-(void)loginCancelled;
@end

@interface YDLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, assign) id<YDLoginViewControllerDelegate> delegate;

- (IBAction)loginUser:(UIButton *)sender;
- (IBAction)cancelLogin:(UIButton *)sender;

@end
