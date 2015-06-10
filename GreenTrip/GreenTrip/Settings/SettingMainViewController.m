//
//  SettingMainViewController.m
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "SettingMainViewController.h"

@interface SettingMainViewController ()

@end

@implementation SettingMainViewController

@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBarHidden = NO;
    //设置下一个页面的返回键。
    /*
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    */
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height - 120) style:UITableViewStyleGrouped];
    myTableView.layer.shadowOffset = CGSizeMake(0, 0.5);
    myTableView.layer.shadowOpacity = 0.15;
    myTableView.separatorStyle = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 20 - 50 - 70, self.view.bounds.size.width - 20 * 2, 50)];
    logoutButton.backgroundColor = myColor;
    logoutButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    logoutButton.layer.shadowOpacity = 0.15;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:logoutButton];
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logout:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
    //清空本地数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults dictionaryRepresentation];
    for (id key in dict) {
        [defaults removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 42;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"cell%lu",(unsigned long)row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    
    
    if (indexPath.row == 0) {

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 16, 200, 16)];
        textLabel.text = @"个人资料修改";
        textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, 42, self.view.bounds.size.width - 30 * 2, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIImageView *indicatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 30 - 9, 16, 9, 17)];
        indicatorImg.image = [UIImage imageNamed:@"偏好箭头36x68px"];
        
        [cell addSubview:textLabel];
        [cell addSubview:lineView];
        [cell addSubview:indicatorImg];
        
    } else if (indexPath.row == 1) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 200, 16)];
        textLabel.text = @"意见反馈";
        textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, 42, self.view.bounds.size.width - 30 * 2, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIImageView *indicatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 30 - 9, 16, 9, 17)];
        indicatorImg.image = [UIImage imageNamed:@"偏好箭头36x68px"];
        
        [cell addSubview:textLabel];
        [cell addSubview:lineView];
        [cell addSubview:indicatorImg];
        
    } else if (indexPath.row == 2) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 200, 16)];
        textLabel.text = @"关于我们";
        textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIImageView *indicatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 30 - 9, 16, 9, 17)];
        indicatorImg.image = [UIImage imageNamed:@"偏好箭头36x68px"];
        
        [cell addSubview:textLabel];
        [cell addSubview:indicatorImg];
        
    } else if (indexPath.row == 3) {
        /*
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        deleteLabel.text = @"退出登录";
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.textColor = [UIColor redColor];
        
        [cell addSubview:deleteLabel];
        */
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {

    } else if (indexPath.row == 1) {

    } else if (indexPath.row == 2) {

    }
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
