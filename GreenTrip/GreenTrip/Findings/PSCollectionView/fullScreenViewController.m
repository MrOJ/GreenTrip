//
//  fullScreenViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/7/16.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "fullScreenViewController.h"

@interface fullScreenViewController ()

@end

@implementation fullScreenViewController

@synthesize image,fullScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fullScreen = [[FullScreenView alloc] initWithImage:image withFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:self.fullScreen];
    
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
