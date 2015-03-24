//
//  textFieldEditDetailsViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/19.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "textFieldEditDetailsViewController.h"

@interface textFieldEditDetailsViewController ()

@end

@implementation textFieldEditDetailsViewController

@synthesize textTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    textStr = [[NSString alloc] init];
    //自定义返回按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //NSLog(@"backTitle = %@",self.navigationItem.backBarButtonItem.title);
    //self.navigationItem.backBarButtonItem.title = @"返回";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    
    enterButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(enter:)];
    [enterButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = enterButton;
    
    editText = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width - 70 * 2, 30)];
    [editText setBorderStyle:UITextBorderStyleRoundedRect];
    if (textTag == 1) {
        [editText setPlaceholder:@"请输入起点"];
    } else if (textTag == 2) {
        [editText setPlaceholder:@"请输入终点"];
    }
    
    [editText setTextColor:[UIColor blackColor]];
    [editText setFont:[UIFont fontWithName:@"Heiti SC" size:13.0f]];
    //NSLog(@"%@",editText.selectedTextRange);
    editText.delegate = self;
    editText.clearButtonMode = UITextFieldViewModeWhileEditing;    //添加清空按钮
    editText.returnKeyType = UIReturnKeySearch;     //设置按键类型
    editText.enablesReturnKeyAutomatically = YES;   //这里设置为无文字就灰色不可点
    self.navigationItem.titleView = editText;
    [editText becomeFirstResponder];     //设置键盘为第一响应
    
    _tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    _tapGr.cancelsTouchesInView = NO;
    _tapGr.numberOfTapsRequired = 1;
    _tapGr.delegate = self;
    [self.view addGestureRecognizer:_tapGr];
    
    search = [[AMapSearchAPI alloc] initWithSearchKey:@"f57ba48c60c524724d3beff7f7063af9" Delegate:self];
    
    //建立TableView, 需要建立在ViewLoad里面，收到数据更新后调用 reloadData
    tipsResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    tipsResultTableView.tag = 1;
    tipsResultTableView.delegate = self;
    tipsResultTableView.dataSource = self;
    [self.view addSubview:tipsResultTableView];
    tipsResultTableView.hidden = YES;
    
}

- (void)back:(id)sender {
    //[editText removeFromSuperview];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)enter:(id)sender {
    if ([editText.text isEqualToString:@""]) {
        //[editText resignFirstResponder];
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        //[alert show];
        //[enterButton setTintColor:[UIColor lightGrayColor]];
        [enterButton setEnabled:NO];
        NSLog(@"请输入内容");

    } else {
        /*
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passName" object:self userInfo:@{@"name":editText.text}];
        [self.navigationController popViewControllerAnimated:YES];
        */
        //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
        [editText resignFirstResponder];
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceKeyword;
        poiRequest.keywords = editText.text;
        poiRequest.city = @[@"杭州"];                 //暂定
        poiRequest.requireExtension = YES;
        
        //发起POI搜索
        [search AMapPlaceSearch: poiRequest];
    }
}

-(BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textStr = field.text;
    textStr = [textStr stringByReplacingCharactersInRange:range withString:string];     //其中的字符串用string代替
    //NSLog(@"field = %@",field.text);
    //NSLog(@"range = %@ string = %@",NSStringFromRange(range),string);
    //NSLog(@"textStr = %@ length of textStr = %lu", textStr,(unsigned long)textStr.length);
    if ([textStr isEqualToString:@""]) {
        [enterButton setEnabled:NO];
        tipsResultTableView.hidden = YES;
    } else {
        [enterButton setEnabled:YES];
        tipsResultTableView.hidden = NO;
        //构造AMapInputTipsSearchRequest对象，keywords为必选项，city为可选项
        AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
        tipsRequest.searchType = AMapSearchType_InputTips;
        tipsRequest.keywords = textStr;
        tipsRequest.city = @[@"杭州"];    //之后会修改
        
        [search AMapInputTipsSearch:tipsRequest];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    tipsResultTableView.hidden = YES;
    
    return YES;
}

/*
//点击空白处收起键盘
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
    [editText resignFirstResponder];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [editText resignFirstResponder];
}
*/

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [editText resignFirstResponder];
    
}

//点击return取消键盘

- (BOOL)textFieldShouldReturn:(UITextField *) textField
{
    
    if ([textField.text isEqualToString:@""]) {
        NSLog(@"请输入内容");
        //textField.returnKeyType = UIReturnKeySearch; //默认：灰色按钮，标有Return
        //textField.enablesReturnKeyAutomatically = YES;
        return NO;
    } else {
        /*
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passName" object:self userInfo:@{@"name":textField.text}];
        [self.navigationController popViewControllerAnimated:YES];
        */
        //textField.returnKeyType = UIReturnKeySearch;  //标有Go的蓝色按钮
        
        //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceKeyword;
        poiRequest.keywords = textField.text;
        poiRequest.city = @[@"杭州"];                 //暂定
        poiRequest.requireExtension = YES;
        
        //发起POI搜索
        [search AMapPlaceSearch: poiRequest];
        
        [textField resignFirstResponder];
        
        return YES;
    }
}


#pragma AmapTipsSearch
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    nameArray = [[NSMutableArray alloc] init];
    districtArray =[[NSMutableArray alloc] init];
    
    if(response.tips.count == 0)
    {
        return;
    }
    
    for (AMapTip *p in response.tips) {
        //strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
        [nameArray addObject:p.name];
        [districtArray addObject:p.district];
    }
    //NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    //NSLog(@"InputTips: %@", result);
    
    [tipsResultTableView reloadData];
    //[self.view addSubview:tipsResultTableView];
    
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (tableView.tag == 1) {
        return [nameArray count];
    } else if (tableView.tag == 2) {
        return [nameArray count];
    } else {
        return 0;
    }
    */
    //NSLog(@"count = %lu",(unsigned long)[nameArray count]);
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {     //如果是tips
        //NSLog(@"1");
        //本函数用于显示每行的内容
        static NSString *MyIdentifier = @"MyIdentifier"; // Try to retrieve from the table view a now-unused cell with the given identifier.
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier]; // If no cell is available, create a new one using the given identifier.
        if (cell == nil)
        {
            // Use the default cell style.
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        }
        // Set up the cell.
        cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [districtArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
    } else if (tableView.tag == 2) {    //如果是确认
        static NSString *MyIdentifier = @"MyIdentifier"; // Try to retrieve from the table view a now-unused cell with the given identifier.
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier]; // If no cell is available, create a new one using the given identifier.
        if (cell == nil)
        {
            // Use the default cell style.
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        }
        // Set up the cell.
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;   //设置右箭头
        cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [addrArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
    } else {
        return nil;
    }

}

//点击后响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
    
    if (tableView.tag == 1) {        //如果是推荐页面
        /*
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passName" object:self userInfo:@{@"name":[nameArray objectAtIndex:indexPath.row]}];
        [self.navigationController popViewControllerAnimated:YES];
        */
        
        //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
        poiRequest.searchType = AMapSearchType_PlaceKeyword;
        poiRequest.keywords = [nameArray objectAtIndex:row];
        poiRequest.city = @[@"杭州"];                 //暂定
        poiRequest.requireExtension = YES;
        
        //发起POI搜索
        [search AMapPlaceSearch: poiRequest];
        
    } else  if (tableView.tag == 2) {    //如果是确认界面
        //NSLog(@"choose!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passValue"
                                                            object:self
                                                          userInfo:@{@"name":[nameArray objectAtIndex:row],
                                                                     @"address":[addrArray objectAtIndex:row],
                                                                     @"location":[locArray objectAtIndex:row],
                                                                     @"textTag":[NSString stringWithFormat:@"%ld",(long)textTag]}];
        
        [sheet removeFromSuperview];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    if(response.pois.count == 0)
    {
        return;
    } else if (response.pois.count == 1) {
        nameArray = [[NSMutableArray alloc] init];
        addrArray = [[NSMutableArray alloc] init];
        locArray = [[NSMutableArray alloc] init];
        
        for (AMapPOI *p in response.pois) {
            [nameArray addObject:p.name];
            [addrArray addObject:p.address];
            [locArray addObject:p.location];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passValue"
                                                            object:self
                                                          userInfo:@{@"name":[nameArray objectAtIndex:0],
                                                                     @"address":[addrArray objectAtIndex:0],
                                                                     @"location":[locArray objectAtIndex:0],
                                                                     @"textTag":[NSString stringWithFormat:@"%ld",(long)textTag]}];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //将POI搜索结果封装数组
        nameArray = [[NSMutableArray alloc] init];
        addrArray = [[NSMutableArray alloc] init];
        locArray = [[NSMutableArray alloc] init];
        for (AMapPOI *p in response.pois) {
            [nameArray addObject:p.name];
            [addrArray addObject:p.address];
            [locArray addObject:p.location];
        }
        
        //跳到confirmTableView界面
        confirmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height- 64 - 40 - 30)];
        confirmTableView.tag = 2;
        confirmTableView.delegate = self;
        confirmTableView.dataSource = self;
        
        sheet = [[customActionSheet alloc] initWithView:confirmTableView AndHeight:self.view.bounds.size.height - 64];
        [sheet showInView:self.view];
    }
    
    /*
    //通过AMapPlaceSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
    */

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
