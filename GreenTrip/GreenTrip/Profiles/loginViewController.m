//
//  loginViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/27.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "loginViewController.h"
#import "YDCrashHandler.h"

@interface loginViewController ()

@end

@implementation loginViewController

@synthesize profileImageView,loginButton,registerButton,loginVC,registrationVC,LoginningView,afterLoginView,logoutImageView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    //self.navigationController.navigationBarHidden = YES;
    //self.tabBarController.tabBar.hidden = NO;
    //NSLog(@"Hello");

    
    //NSLog(@"%d",[YDConfigurationHelper getBoolValueForConfigurationKey:@"isLogout"]);
    if ([YDConfigurationHelper getBoolValueForConfigurationKey:@"isLogout"]) {
        //NSLog(@"Yes!");
        LoginningView.hidden = NO;
        afterLoginView.hidden = YES;
    } else {
        if (!bYDRegistrationRequired || [YDConfigurationHelper getBoolValueForConfigurationKey:bYDRegistered])
        {
            // you arrive here if either the registration is not required or yet achieved
            if (!bYDLoginRequired)
            {
                LoginningView.hidden = YES;
                afterLoginView.hidden = NO;
                
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.logoutImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.logoutImageView.clipsToBounds = YES;
    self.logoutImageView.layer.borderWidth = 3.0f;
    self.logoutImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    */
    
}

- (void)recNotification:(NSNotification *)notification {
    NSDictionary *getDic = [notification userInfo];
    getStr = [getDic objectForKey:@"isLogout"];
    
}

- (IBAction)getLogin:(id)sender {
    self.loginVC= [[YDLoginViewController alloc] init];
    self.loginVC.delegate=self;
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
    NSLog(@"Hello");
    
    /*
    //get 数据解析
    //请求管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //发起请求
    [manager GET:@"http://121.40.218.33:1210/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    */
    //1.管理器
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    NSDictionary *dict = @{ @"username":@"xn", @"password":@"123" };
    
    //3.请求
    [manager GET:@"121.40.218.33:1200/" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    */
}

- (IBAction)getRegister:(id)sender {
    self.registrationVC =[[YDRegistrationViewController alloc] init];
    self.registrationVC.delegate=self;
    
    //[self.navigationController pushViewController:registrationVC animated:YES];
    
    [self presentViewController:registrationVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Registration Delegates
-(void)registeredWithError
{
    //called from RegistrationViewcontroller if registration failed
}

-(void)registeredWithSuccess
{
    //called from RegistrationViewcontroller if the registration with success
    //
    if (bYDShowLoginAfterRegistration)
    {
        self.loginVC = [[YDLoginViewController alloc] init];
        self.loginVC.delegate=self;
        
        [self.navigationController pushViewController:loginVC animated:NO];
        //[self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        /*
        self.profilesMainVC= [[ProfilesMainViewController alloc] init];
        //装载Storyboard中的ProfilesViewController
        UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.profilesMainVC = [stryBoard instantiateViewControllerWithIdentifier: @"myStoryboard"];
        [self.navigationController pushViewController:profilesMainVC animated:NO];
        */
        LoginningView.hidden = YES;
        afterLoginView.hidden = NO;
    }
}

-(void)cancelRegistration
{
    //called from RegistrationViewcontroller if cancel is pressed
}
#pragma Login delegates
-(void)loginWithSuccess
{
    /*
    //called when login with success
    self.profilesMainVC= [[ProfilesMainViewController alloc] init];
    
    //装载Storyboard中的ProfilesViewController
    UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.profilesMainVC = [stryBoard instantiateViewControllerWithIdentifier: @"myStoryboard"];
    
    [self.navigationController pushViewController:profilesMainVC animated:NO];
    */
    [YDConfigurationHelper setBoolValueForConfigurationKey:@"isLogout" withValue:NO];
    
    LoginningView.hidden = YES;
    afterLoginView.hidden = NO;
}

-(void)loginWithError
{
    //called when login with error
}
-(void)loginCancelled
{
    //called when login is cancelled
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
