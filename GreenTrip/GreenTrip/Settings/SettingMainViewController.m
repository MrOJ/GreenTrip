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

@synthesize tableViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    //设置下一个页面的返回键。
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.tabBarController.tabBar.hidden = YES;
    
    tableViewController.delegate = self;
    tableViewController.dataSource = self;

}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return 64;
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 30;
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"cell%lu",(unsigned long)row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"修改资料";
        /*
        UIImageView *findingLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        findingLogoImgView.image = [UIImage imageNamed:@"finding_logo"];
        
        [cell addSubview:findingLogoImgView];
        
        
        UILabel *findingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        findingLabel.text = @"个人资料修改";
        
        [cell addSubview:findingLabel];
        */
        
    } else {
        cell.textLabel.text = @"关于";
        /*
        UILabel *findingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        findingLabel.text = @"关于";
        
        [cell addSubview:findingLabel];
        */
    }
    
    
    //NSLog(@"section = %ld",(long)indexPath.section);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
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
