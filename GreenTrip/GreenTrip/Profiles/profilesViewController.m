//
//  profilesViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/4/24.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "profilesViewController.h"

@interface profilesViewController ()

@end

@implementation profilesViewController

@synthesize usernameTextField,passwordTextField,LoginView,afterLoginView;
@synthesize portraitButton,backgroundImageView,nicknameLabel,messageLabel,portraitView;
@synthesize takingbikeNumLabel,takingbusNumLabel,reducingLabel,percentLabel;
@synthesize imagePickerController;
@synthesize forgetPassButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    
    [self loginState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    portraitView.layer.masksToBounds = YES;
    portraitView.layer.borderWidth = 0.5f;
    portraitView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    /*
    portraitButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    portraitButton.layer.shadowOffset = CGSizeMake(1, 1);
    portraitButton.layer.shadowOpacity = 0.5;
    portraitButton.layer.shadowRadius = 10.0;
    */
    //实际这个地方要删去
    //[YDConfigurationHelper setBoolValueForConfigurationKey:@"isLogout" withValue:YES];
    
    /*
    //获取本地userdefault头像信息
    if ([YDConfigurationHelper getObjectValueForConfigurationKey:@"portrait"] != nil) {
        //NSLog(@"has portrait");
        NSData *imageDta = [YDConfigurationHelper getObjectValueForConfigurationKey:@"portrait"];
        UIImage *image = [UIImage imageWithData:imageDta];
        [portraitButton setImage:image forState:UIControlStateNormal];
    }
    
    UIImage *portraitImg = [UIImage imageNamed:@"proxy.png"];
    NSData *data = UIImagePNGRepresentation(portraitImg);
    [YDConfigurationHelper setBoolValueForConfigurationKey:@"portrait" withValue:data];
    */
    
    forgetPassButton.hidden = YES;
}

//进入注册界面
- (void)goRegister:(id)sender {
    registrationViewController *registerVC = [[registrationViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    self.navigationItem.title = @"";
    
}

//进入设置界面
- (void)goSetting:(id)sender {
    SettingMainViewController *settingMainVC = [[SettingMainViewController alloc] init];
    [self.navigationController pushViewController:settingMainVC animated:YES];
}

- (IBAction)login:(id)sender {
    if (([self.usernameTextField.text length]== 0 ) || ([self.passwordTextField.text length] == 0))
    {
        [self showErrorWithMessage:@"输入不能为空"];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":self.usernameTextField.text, @"password":[self.passwordTextField.text MD5] };
        
        //3.请求
        [manager GET:@"http://121.40.218.33:1200/login" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSString *getLogin = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"login"]];
            
            if ([getLogin isEqualToString:@"0"]) {
                NSLog(@"登录成功！");
                [passwordTextField resignFirstResponder];
                //-------登录服务器后下载个人资料数据实现----------
                NSString *getUsername = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"username"]];
                NSString *getNickname = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"nickname"]];
                NSString *getPortraitImage = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"portrait_image"]];
                NSString *getPhoneNumber = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"phone_number"]];
                NSString *getEmail = [responseObject objectForKey:@"email"];
                NSString *getSex = [responseObject objectForKey:@"sex"];
                NSString *getAge = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"age"]];
                NSString *getSignature = [responseObject objectForKey:@"signature"];
                NSString *getBirthday = [responseObject objectForKey:@"birthday"];
                
                NSString *getTransCount= [responseObject objectForKey:@"trans_count"];
                NSString *getBikeDistance = [responseObject objectForKey:@"bike_distance"];
                NSString *getReduceCarbon = [responseObject objectForKey:@"reduce_carbon"];
                
                nicknameLabel.text = getNickname;
                messageLabel.text  = getSignature;
                
                if (getTransCount) {
                    takingbusNumLabel.text = getTransCount;
                    takingbikeNumLabel.text = getBikeDistance;
                    reducingLabel.text = getReduceCarbon;
                } else {
                    takingbusNumLabel.text = @"0";
                    takingbikeNumLabel.text = @"0.0";
                    reducingLabel.text = @"0.0";
                }
                
                //利用SDWenImage下载图片
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.218.33:1200/syncportrait?image=%@",getPortraitImage]];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    // progression tracking code
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (error) {
                        NSLog(@"头像下载出错error %@",error);
                    } else {
                        if (image) {
                            NSLog(@"头像下载成功！");
                            [portraitButton setImage:image forState:UIControlStateNormal];
                            //将图片数据存入NSUserDefaults中
                            NSData *data = UIImagePNGRepresentation(image);
                            [YDConfigurationHelper setDataValueForConfigurationKey:data withValue:@"portrait"];

                        }
                    }
                }];
                
                [YDConfigurationHelper setStringValueForConfigurationKey:getUsername withValue:@"username"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getNickname withValue:@"nickname"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getPhoneNumber withValue:@"phone_number"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getEmail withValue:@"email"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getSex withValue:@"sex"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getAge withValue:@"age"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getSignature withValue:@"signature"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getBirthday withValue:@"birthday"];
                
                [YDConfigurationHelper setStringValueForConfigurationKey:getTransCount withValue:@"trans_count"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getBikeDistance withValue:@"bike_distance"];
                [YDConfigurationHelper setStringValueForConfigurationKey:getReduceCarbon withValue:@"reduce_carbon"];
                
                //改变登录状态
                [self loginState];
                
            } else if ([getLogin isEqualToString:@"1"]) {
                self.passwordTextField.text = @"";
                [self.passwordTextField becomeFirstResponder];
                [self showErrorWithMessage:@"密码错误，请重试"];
            } else {
                self.usernameTextField.text = @"";
                self.passwordTextField.text = @"";
                [self showErrorWithMessage:@"用户名不存在，请重试"];
                [self.usernameTextField becomeFirstResponder];
            }
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorWithMessage:@"连接失败，请检测网络"];
        }];
    }
}

- (IBAction)forgetPassword:(id)sender {

}

- (IBAction)useQQ:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.yOffset = -100;     //改变位置
    HUD.mode = MBProgressHUDModeText;
    
    HUD.delegate = self;
    HUD.labelText = @"接口即将接入，尽请期待！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (IBAction)useWeChat:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.yOffset = -100;     //改变位置
    HUD.mode = MBProgressHUDModeText;
    
    HUD.delegate = self;
    HUD.labelText = @"接口即将接入，尽请期待！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];}

- (IBAction)useWeibo:(id)sender {
    /*
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.yOffset = -100;     //改变位置
    HUD.mode = MBProgressHUDModeText;
    
    HUD.delegate = self;
    HUD.labelText = @"接口即将接入，尽请期待！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    */
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

//点击头像上传头像
- (IBAction)uploadPortrait:(id)sender {
    NSLog(@"上传头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    //actionSheet.tintColor = myColor;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [portraitButton setImage:editedImage forState:UIControlStateNormal];
    //将图片传至服务器，并且存入本地userdefaults保存
    NSData *data = UIImagePNGRepresentation(editedImage);
    [YDConfigurationHelper setDataValueForConfigurationKey:data withValue:@"portrait"];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        //NSLog(@"修改完成。");
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"portrait_%@.png", str];
        
        NSString *usernameStr = [NSString stringWithFormat:@"%@",[YDConfigurationHelper getStringValueForConfigurationKey:@"username"]];

        NSDictionary *dict = [[NSDictionary alloc] init];
        if (![usernameStr isEqualToString:@""]) {
            dict = @{ @"username":usernameStr};
            
            /*
            NSMutableURLRequest *urlrequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://121.40.218.33:1200/upload" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:@"myfile" fileName:fileName mimeType:@"image/png"];
                
            } error:nil];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSProgress *progress = nil;
            
            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:urlrequest progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.yOffset = -100;     //改变位置
                    HUD.mode = MBProgressHUDModeText;
                    
                    HUD.delegate = self;
                    HUD.labelText = @"头像上传失败，请重试";
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1];
                } else {
                    NSLog(@"图片修改成功！");
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.yOffset = -100;     //改变位置
                    HUD.mode = MBProgressHUDModeText;
                    
                    HUD.delegate = self;
                    HUD.labelText = @"头像修改成功";
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1];
                }
            }];
            [uploadTask resume];
            */
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://121.40.218.33:1200/upload" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
                [formData appendPartWithFileData:data name:@"myfile" fileName:fileName mimeType:@"image/png"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"Success: %@", responseObject);
                NSLog(@"finding上传成功！");
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.yOffset = -100;     //改变位置
                HUD.mode = MBProgressHUDModeText;
                
                HUD.delegate = self;
                HUD.labelText = @"头像修改成功";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self showErrorWithMessage:@"上传失败，请重试"];
            }];
        } else {
            [self showErrorWithMessage:@"用户名不存在，请重试"];
        }

    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"拍照");
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            break;
        case 1:
            NSLog(@"从手机相册选择");
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            break;
        default:
            break;
    }
}

// 修改ActionSheet按钮字体
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    //ios 8的设定方案
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor lightGrayColor]];
}

//登录的状态改变函数
- (void)loginState
{
    for (id object in self.navigationController.navigationBar.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            //NSLog(@"hello!!");
            [(UIButton *)object removeFromSuperview];
        }
    }
    
    if (![[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] isEqualToString:@""]) {
        NSLog(@"个人资料界面");
        LoginView.hidden = YES;
        afterLoginView.hidden = NO;
        
        self.navigationItem.title = @"个人资料";
        
        /*
        UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"4设置130x80"] style:UIBarButtonItemStylePlain target:self action:@selector(goSetting:)];
        self.navigationItem.rightBarButtonItem = settingButton;
        */
        
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 25, 10, 25, 25)];
        [settingButton setImage:[UIImage imageNamed:@"4设置130x80"] forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(goSetting:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:settingButton];
        
        NSString *nicknameStr = [NSString stringWithFormat:@"%@",[YDConfigurationHelper getStringValueForConfigurationKey:@"nickname"]];
        //NSLog(@"nickname = %@",nicknameStr);
        //NSLog(@"username = %@",[YDConfigurationHelper getStringValueForConfigurationKey:@"username"]);
        //获取本地用户名信息
        if ([nicknameStr isEqualToString:@"<null>"] || [nicknameStr isEqualToString:@""]) {
            nicknameLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"username"];
        } else {
            nicknameLabel.text = nicknameStr;
        }
        
        NSString *getTakingBus = [YDConfigurationHelper getStringValueForConfigurationKey:@"trans_count"];
        NSString *getBike      = [YDConfigurationHelper getStringValueForConfigurationKey:@"bike_distance"];
        NSString *getReduce    = [YDConfigurationHelper getStringValueForConfigurationKey:@"reduce_carbon"];
        NSString *getMsg       = [YDConfigurationHelper getStringValueForConfigurationKey:@"signature"];
        
        if (![getTakingBus isEqualToString:@""]) {
            takingbusNumLabel.text = takingbusNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"trans_count"];
        } else {
            takingbusNumLabel.text = @"0";
        }
        
        if (![getBike isEqualToString:@""]) {
            takingbikeNumLabel.text = takingbusNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"bike_distance"];
        } else {
            takingbikeNumLabel.text = @"0.0";
        }
        
        if (![getReduce isEqualToString:@""]) {
            reducingLabel.text = takingbusNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"reduce_carbon"];
        } else {
            reducingLabel.text = @"0.0";
        }
        
        if (![getMsg isEqualToString:@""]) {
            messageLabel.text = takingbusNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"signature"];
        } else {
            messageLabel.text = @"这家伙很懒，什么也没留下";
        }

        /*
        messageLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"signature"];
        takingbusNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"trans_count"];
        takingbikeNumLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"bike_distance"];
        reducingLabel.text = [YDConfigurationHelper getStringValueForConfigurationKey:@"reduce_carbon"];
        */
        
        //获取本地userdefault头像信息
        NSData *imageData = [YDConfigurationHelper getObjectValueForConfigurationKey:@"portrait"];
        //NSLog(@"imageData = %@",imageData);
        if (imageData != nil) {
            UIImage *image = [UIImage imageWithData:imageData];
            [portraitButton setImage:image forState:UIControlStateNormal];
        } else {
            [portraitButton setImage:[UIImage imageNamed:@"62x62默认头像"] forState:UIControlStateNormal];
        }
        
    } else {
        
        if (!bYDLoginRequired)
        {
            NSLog(@"登录界面");
            LoginView.hidden = NO;
            afterLoginView.hidden = YES;
            
            self.navigationItem.title = @"登录帐号";
            
            /*
            UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goRegister:)];
            self.navigationItem.rightBarButtonItem = registerButton;
            */
            
            UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 25, 10, 25, 25)];
            [settingButton setImage:[UIImage imageNamed:@"4设置130x80"] forState:UIControlStateNormal];
            [settingButton addTarget:self action:@selector(goSetting:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationController.navigationBar addSubview:settingButton];
            
            UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 80, 20)];
            registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registerButton addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
            [registerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [self.navigationController.navigationBar addSubview:registerButton];
            
        }
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        
        [self.view endEditing:YES];
        
    }
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
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
