//
//  sendMessagesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/25.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "sendMessagesViewController.h"

@interface sendMessagesViewController ()

@end

@implementation sendMessagesViewController

@synthesize image;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navigationBar.barTintColor = myColor;
    [self.view addSubview:navigationBar];
    
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 50, 50)];
    [exitButton setTitle:@"取消" forState:UIControlStateNormal];
    [exitButton  addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:exitButton];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 5 - 50, 15, 50, 50)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton  addTarget:self action:@selector(goSending:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:sendButton];
    
    //UITextField *msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + 64, self.view.bounds.size.width - 10 * 2 - 90 - 10, 200)];
    UITextView *msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20 + 64, self.view.bounds.size.width - 10 * 2 - 90 - 10, 200)];
    msgTextView.font = [UIFont systemFontOfSize:15.0f];
    msgTextView.textColor = [UIColor darkGrayColor];
    msgTextView.tintColor = myColor;
    [self.view addSubview:msgTextView];
    
    [msgTextView becomeFirstResponder];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 90, 20 + 64, 90, 120)];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 3.0f;
    imageView.image = image;
    float width = 90;
    //[imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    CGFloat objectWidth = imageView.image.size.width;
    CGFloat objectHeight = imageView.image.size.height;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    imageView.frame = CGRectMake(self.view.bounds.size.width - 10 - 90, 20 + 64, width, scaledHeight);
    [self.view addSubview:imageView];
    
}

- (void)cancel:(id)sender {
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)goSending:(id)sender {
    NSLog(@"send");
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
