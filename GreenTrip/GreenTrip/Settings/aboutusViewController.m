//
//  aboutusViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/6/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "aboutusViewController.h"

@interface aboutusViewController ()

@end

@implementation aboutusViewController

@synthesize iconImageView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"关于我们";
    
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
    
    iconImageView.layer.cornerRadius = 10.0f;
    
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
