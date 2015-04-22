//
//  FindingMainViewController.m
//  GreenTrips
//
//  Created by Mr.OJ on 15/1/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "FindingMainViewController.h"

@interface FindingMainViewController ()

@end

@implementation FindingMainViewController

@synthesize findingTableViewController;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    findingTableViewController.delegate = self;
    findingTableViewController.dataSource = self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


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
    
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 20, 18, 8, 14)];
    arrowImgView.image = [UIImage imageNamed:@"箭头30x56"];
    [cell addSubview:arrowImgView];
    
    if (indexPath.section == 0) {
        //cell.textLabel.text = @"绿出行圈";
        
        UIImageView *findingLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 22, 23)];
        findingLogoImgView.image = [UIImage imageNamed:@"搜搜86x90"];
        
        [cell addSubview:findingLogoImgView];
        
        UILabel *findingLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 200, 30)];
        findingLabel.text = @"绿出行圈";
        
        [cell addSubview:findingLabel];
        
        
    } else {
        //cell.textLabel.text = @"减排排行榜";
        
        UIImageView *findingLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17, 27, 17)];
        findingLogoImgView.image = [UIImage imageNamed:@"排行榜208x66"];
        
        [cell addSubview:findingLogoImgView];
        
        UILabel *findingLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 200, 30)];
        findingLabel.text = @"减排排行榜";
        
        [cell addSubview:findingLabel];
    }
    
    
    //NSLog(@"section = %ld",(long)indexPath.section);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        collectionViewController *collectionVC = [[collectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
        
        //设置下一个页面的返回键。
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        
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
