//
//  choosePreferViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/24.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "choosePreferViewController.h"

@implementation choosePreferViewController

- (void)viewDidLoad {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = @"偏好选择";
    
    choosePreferTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    choosePreferTV.delegate = self;
    choosePreferTV.dataSource = self;
    [self.view addSubview:choosePreferTV];
    
    preferArray = [[NSArray alloc] initWithObjects:@"最快捷",@"最经济",@"最少换乘",@"最少步行",@"最舒适",@"不乘地铁", nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [preferArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //本函数用于显示每行的内容
    static NSString *MyIdentifier = @"MyIdentifier"; // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier]; // If no cell is available, create a new one using the given identifier.
    if (cell == nil)
    {
        // Use the default cell style.
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    // Set up the cell.
    cell.textLabel.text = [preferArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passPattern"
                                                        object:self
                                                      userInfo:@{@"pattern":[NSString stringWithFormat:@"%ld",(long)row]}];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

