//
//  updateProfilesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/6/11.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "updateProfilesViewController.h"

@interface updateProfilesViewController ()

@end

@implementation updateProfilesViewController

@synthesize datePick,sexPicker;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    */
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
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 80, 15, 80, 20)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.navigationController.navigationBar addSubview:saveButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"个人资料修改";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self drawSubView];
    
    self.datePick = [[UIDatePicker alloc] init];
    self.datePick.datePickerMode = UIDatePickerModeDate;
    [self.datePick addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    
    sexPicker = [[UIPickerView alloc] init];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
- (void)save:(id)sender {
    if ([self isValidateEmail:emailTextField.text] || [emailTextField.text isEqualToString:@""]) {
        if ([self isMobileNumber:phoneTextField.text] || [phoneTextField.text isEqualToString:@""]) {
            NSLog(@"save");
            
            //更新数据库数据
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            //2.设置登录参数
            NSDictionary *dict = @{ @"username":[YDConfigurationHelper getStringValueForConfigurationKey:@"username"],
                                    @"nickname":nicknameTextField.text,
                                    @"signature":signatureTextField.text,
                                    @"sex":sexTextField.text,
                                    @"birthday":birthdayTextField.text,
                                    @"email":emailTextField.text,
                                    @"phone_number":phoneTextField.text};
            
            //3.请求
            [manager GET:@"http://121.40.218.33:1200/updateProfiles" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"GET --> %@", responseObject); //自动返回主线程
                /*
                BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"勾44x32px"] text:@"保存成功！"];  //图片需要改变
                hud.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
                
                // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
                [self.view addSubview:hud];
                [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
                    [hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                */
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.delegate = self;
                HUD.labelText = @"保存成功";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                
                [YDConfigurationHelper setStringValueForConfigurationKey:nicknameTextField.text withValue:@"nickname"];
                [YDConfigurationHelper setStringValueForConfigurationKey:phoneTextField.text withValue:@"phone_number"];
                [YDConfigurationHelper setStringValueForConfigurationKey:emailTextField.text withValue:@"email"];
                [YDConfigurationHelper setStringValueForConfigurationKey:sexTextField.text withValue:@"sex"];
                [YDConfigurationHelper setStringValueForConfigurationKey:signatureTextField.text withValue:@"signature"];
                [YDConfigurationHelper setStringValueForConfigurationKey:birthdayTextField.text withValue:@"birthday"];
                
            } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showErrorWithMessage:@"连接失败，请检测网络"];
            }];
            
        } else {
            [self showErrorWithMessage:@"手机号码不正确，请重试"];
            [phoneTextField becomeFirstResponder];
        }
    } else {
        [self showErrorWithMessage:@"邮箱格式不正确，请重试"];
        [emailTextField becomeFirstResponder];
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawSubView
{
    CGSize mainSize = self.view.bounds.size;
    
    //=====================View1=====================
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, mainSize.width, 42 * 3)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.shadowOffset = CGSizeMake(0, 0.5f);
    view1.layer.shadowOpacity = 0.15f;
    [self.view addSubview:view1];
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 100, 16)];
    nicknameLabel.text = @"昵称";
    nicknameLabel.font = [UIFont systemFontOfSize:16.0f];
    
    nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 16, 160, 16)];
    nicknameTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"nickname"];
    nicknameTextField.textColor = [UIColor lightGrayColor];
    nicknameTextField.delegate = self;
    nicknameTextField.tag = 0;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 41, mainSize.width - 20 * 2, 1)];
    lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42 + 12, 100, 16)];
    signatureLabel.text = @"个性签名";
    signatureLabel.font = [UIFont systemFontOfSize:16.0f];
    
    signatureTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 42 + 12, 160, 16)];
    signatureTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"signature"];
    signatureTextField.textColor = [UIColor lightGrayColor];
    signatureTextField.delegate = self;
    signatureTextField.tag = 1;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 42 + 41, mainSize.width - 20 * 2, 1)];
    lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42 + 42 + 12, 100, 16)];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont systemFontOfSize:16.0f];
    
    sexTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 42 + 42 + 12, 160, 16)];
    sexTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"sex"];
    sexTextField.textColor = [UIColor lightGrayColor];
    sexTextField.tag = 2;
    sexTextField.delegate = self;
    
    [view1 addSubview:nicknameLabel];
    [view1 addSubview:nicknameTextField];
    [view1 addSubview:lineView1];
    [view1 addSubview:signatureLabel];
    [view1 addSubview:signatureTextField];
    [view1 addSubview:lineView2];
    [view1 addSubview:sexLabel];
    [view1 addSubview:sexTextField];
    
    //=====================View2=====================
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20+42*3+20, 100, 16)];
    openLabel.text = @"[非公开]";
    openLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:openLabel];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 5 + 42 * 3 + 40, mainSize.width, 42 * 3)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.shadowOffset = CGSizeMake(0, 0.5f);
    view2.layer.shadowOpacity = 0.15f;
    [self.view addSubview:view2];
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 100, 16)];
    birthdayLabel.text = @"生日";
    birthdayLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 16, 160, 16)];
    birthdayTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"birthday"];
    birthdayTextField.textColor = [UIColor lightGrayColor];
    birthdayTextField.tag = 3;
    birthdayTextField.delegate = self;
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(20, 41, mainSize.width - 20 * 2, 1)];
    lineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42 + 12, 100, 16)];
    emailLabel.text = @"邮箱";
    emailLabel.font = [UIFont systemFontOfSize:16.0f];
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 42 + 12, 160, 16)];
    emailTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"email"];
    emailTextField.textColor = [UIColor lightGrayColor];
    emailTextField.tag = 4;
    emailTextField.delegate = self;
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(20, 42 + 41 , mainSize.width - 20 * 2, 1)];
    lineView4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42 + 42 + 12, 100, 16)];
    phoneLabel.text = @"手机号码";
    phoneLabel.font = [UIFont systemFontOfSize:16.0f];
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 42 + 42 + 12, 160, 16)];
    phoneTextField.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"phone_number"];
    phoneTextField.textColor = [UIColor lightGrayColor];
    phoneTextField.tag = 5;
    phoneTextField.delegate = self;
    
    [view2 addSubview:birthdayLabel];
    [view2 addSubview:birthdayTextField];
    [view2 addSubview:lineView3];
    [view2 addSubview:emailLabel];
    [view2 addSubview:emailTextField];
    [view2 addSubview:lineView4];
    [view2 addSubview:phoneLabel];
    [view2 addSubview:phoneTextField];
    
    
}

- (void)chooseDate:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    birthdayTextField.text = dateString;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"tag = %ld",(long)textField.tag);
    
    if (textField.tag != 3 && textField.tag != 2) {
        if (self.datePick.superview) {
            [self.datePick removeFromSuperview];
        }
        
        if (self.sexPicker.superview) {
            [self.sexPicker removeFromSuperview];;
        }
        return YES;
    }
    
    if (textField.tag == 2) {
        
        if (self.datePick.superview) {
            [self.datePick removeFromSuperview];
        }
        [sexTextField resignFirstResponder];
        [nicknameTextField resignFirstResponder];
        [signatureTextField resignFirstResponder];
        [sexTextField resignFirstResponder];
        [birthdayTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [phoneTextField resignFirstResponder];

        //[textField resignFirstResponder];
        
        sexPicker.frame = CGRectMake(0, self.view.bounds.size.height - 180, self.view.bounds.size.width, 180);
        [self.view addSubview:sexPicker];
    }
    
    if (textField.tag == 3) {
        [sexTextField resignFirstResponder];
        [nicknameTextField resignFirstResponder];
        [signatureTextField resignFirstResponder];
        [sexTextField resignFirstResponder];
        [birthdayTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [phoneTextField resignFirstResponder];
        
        if (self.sexPicker.superview) {
            [self.sexPicker removeFromSuperview];
        }
        
        [textField resignFirstResponder];
        
        self.datePick.frame = CGRectMake(0, self.view.bounds.size.height - 180, self.view.bounds.size.width, 180);
        [self.view addSubview:self.datePick];
        
    }
    
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDalegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"男";
    } else {
        return @"女";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        sexTextField.text = @"男";
    } else {
        sexTextField.text = @"女";
    }
}

//判断邮箱格式是否正确
-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//判断手机号码是否正确
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
