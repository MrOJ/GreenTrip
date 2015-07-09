//
//  feedbackViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/6/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()

@end

@implementation feedbackViewController

@synthesize emailTextField;
@synthesize phoneTextField;
@synthesize contentTextView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"意见反馈";
    
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
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 80, 15, 80, 20)];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.navigationController.navigationBar addSubview:sendButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)send:(id)sender {
    
    if (![contentTextView.text isEqualToString:@""]) {
        //更新数据库数据
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":[YDConfigurationHelper getStringValueForConfigurationKey:@"username"],
                                @"email":emailTextField.text,
                                @"phone":phoneTextField.text,
                                @"content":contentTextView.text};
        
        //3.请求
        [manager GET:@"http://192.168.1.104:1200/uploadfeedbacksInfo" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = @"保存成功";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.yOffset = -100;     //改变位置
            HUD.mode = MBProgressHUDModeText;
            
            HUD.delegate = self;
            HUD.labelText = @"发送失败，请检查网络设置";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
        }];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.yOffset = -100;     //改变位置
        HUD.mode = MBProgressHUDModeText;
        
        HUD.delegate = self;
        HUD.labelText = @"反馈内容不能为空";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
    
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
