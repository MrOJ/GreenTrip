//
//  collectionViewController.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "collectionViewController.h"

@interface collectionViewController ()

@end

@implementation collectionViewController

@synthesize collectionView;
@synthesize getFindingsNum;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"相机25x21px"] landscapeImagePhone:[UIImage imageNamed:@"相机25x21px"]  style:UIBarButtonItemStylePlain target:self action:@selector(openCamera:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    //头部主动刷新
    //[self.collectionView.header beginRefreshing];
    refreshTime    = 0;
    refreshIndex   = 0;
    loadMoreIndex  = 0;
    loadMoreTime   = 0;
    getFindingsNum = @"0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"绿出行圈";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 114)];
    //self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf loadNewData];
    }];
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        // 下拉刷新
        [weakSelf loadMoreData];
    }];
    
    [self.collectionView.legendFooter setHidden:YES];
    // 马上进入刷新状态
    itemsArray = [[NSMutableArray alloc] init];
    capitionArray = [[NSMutableArray alloc] init];
    nicknameArray = [[NSMutableArray alloc] init];
    portraitImgArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recNotification:) name:@"passValue" object:nil];
    
    [self.collectionView.legendHeader beginRefreshing];
    
}

- (void)recNotification:(NSNotification *)notification {
    NSDictionary *getDic = [notification userInfo];
    textComments = [getDic objectForKey:@"message"];
    
    [itemsArray insertObject:sendingImg atIndex:0];
    [capitionArray insertObject:textComments atIndex:0];
    [nicknameArray insertObject:[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] atIndex:0];
    NSData *imageData = [YDConfigurationHelper getObjectValueForConfigurationKey:@"portrait"];
    if (imageData != nil) {
        [portraitImgArray insertObject:[UIImage imageWithData:imageData] atIndex:0];
    } else {
        [portraitImgArray insertObject:[UIImage imageNamed:@"default_image"] atIndex:0];
    }
    
    //上传图片至数据库
    [self uploadFindingsInfo];
    
    refreshTime += 1;
    
    [self.collectionView reloadData];
    [self.collectionView.header beginRefreshing];;
}

- (void)loadNewData {
    NSLog(@"refresh time = %ld",(long)refreshTime);
    NSLog(@"refresh index = %ld",(long)refreshIndex);
    NSLog(@"finding num = %@",getFindingsNum);
    
    if (![[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] isEqualToString:@""]) {
        self.collectionView.collectionViewDelegate = self;
        self.collectionView.collectionViewDataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.collectionView.numColsPortrait = 2;
        self.collectionView.numColsLandscape = 3;
        
        //[self.collectionView reloadData];
        
        //[self.collectionView.legendHeader endRefreshing];   //结束刷新
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":[YDConfigurationHelper getStringValueForConfigurationKey:@"username"],
                                @"push_time": dateStr,
                                @"index":[NSString stringWithFormat:@"%ld",(long)refreshIndex],
                                @"refresh_times":[NSString stringWithFormat:@"%ld",(long)refreshTime],
                                @"load_more":@"0",
                                @"findings_num":getFindingsNum};  //此处index需要修改  load_more：0-刷新 1-加载更多
        //3.请求
        [manager GET:@"http://192.168.1.123:1200/syncFindingInfo" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSArray *getUsernameArray = [[NSArray alloc] init];
            getUsernameArray = [responseObject objectForKey:@"username_list"];
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            if ([stateStr isEqualToString:@"0"]) {
                
                if (itemsArray.count == 0) {
                    [capitionArray addObjectsFromArray:[responseObject objectForKey:@"text_comment_list"]];
                    [nicknameArray addObjectsFromArray:[responseObject objectForKey:@"username_list"]];
                    [portraitImgArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                    [itemsArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                } else {
                    [capitionArray insertObjects:[responseObject objectForKey:@"text_comment_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [nicknameArray insertObjects:[responseObject objectForKey:@"username_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [portraitImgArray insertObjects:[responseObject objectForKey:@"portrait_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [itemsArray insertObjects:[responseObject objectForKey:@"finding_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                }
                
                getFindingsNum = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"findings_num"]];
                
                refreshIndex += getUsernameArray.count;
            } else {
                NSLog(@"已无更多！");
            }
            refreshTime  += 1;
            [self.collectionView reloadData];
            [self.collectionView.legendHeader endRefreshing];   //结束刷新
            
            [self.collectionView.legendFooter setHidden:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self showErrorWithMessage:@"连接失败，请重试"];
        }];
    } else {
        [self showErrorWithMessage:@"请登录"];
    }
    
}

- (void)loadMoreData {
    /*
    [self.collectionView reloadData];
    
    [self.collectionView.legendFooter endRefreshing];
    */
    NSLog(@"refresh index = %ld",(long)refreshIndex);
    
    if (![[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] isEqualToString:@""]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //2.设置登录参数
        NSDictionary *dict = @{ @"username":[YDConfigurationHelper getStringValueForConfigurationKey:@"username"],
                                @"push_time": dateStr,
                                @"index":[NSString stringWithFormat:@"%lu",loadMoreIndex + itemsArray.count ],
                                @"refresh_times":[NSString stringWithFormat:@"%ld",(long)loadMoreTime],
                                @"load_more":@"1"};  //此处index需要修改
        //3.请求
        [manager GET:@"http://192.168.1.123:1200/syncFindingInfo" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSArray *getUsernameArray = [[NSArray alloc] init];
            getUsernameArray = [responseObject objectForKey:@"username_list"];
            
            NSString *getState = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            NSLog(@"state = %@",getState);
            
            if ([getState isEqualToString:@"0"]) {
                NSLog(@"load more");
                [capitionArray addObjectsFromArray:[responseObject objectForKey:@"text_comment_list"]];
                [nicknameArray addObjectsFromArray:[responseObject objectForKey:@"username_list"]];
                [portraitImgArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                [itemsArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                
                loadMoreIndex += getUsernameArray.count;
                [self.collectionView reloadData];
                [self.collectionView.legendFooter endRefreshing];   //结束刷新
                
            } else {
                //[self.collectionView.legendFooter setTitle:@"暂无更多" forState:MJRefreshFooterStateNoMoreData];
                //[self.collectionView.legendFooter setState:MJRefreshFooterStateNoMoreData];
                //已经全部加载完毕
                [self.collectionView.legendFooter noticeNoMoreData];
            }
            
            loadMoreTime += 1;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self showErrorWithMessage:@"连接失败，请重试"];
        }];
    } else {
        [self showErrorWithMessage:@"请登录"];
    }
    
}

- (void)openCamera:(id)sender
{
    NSLog(@"open camera");
    if (![[YDConfigurationHelper getStringValueForConfigurationKey:@"username"] isEqualToString:@""]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];

    } else {
        [self showErrorWithMessage:@"登录后即可发布状态"];
    }
    
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        sendingImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        sendMessagesViewController *sendMessageVC = [[sendMessagesViewController alloc] init];
        sendMessageVC.image = sendingImg;
        [self presentViewController:sendMessageVC animated:YES completion:^{
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //打开选择照片后设定顶部的属性
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    viewController.navigationController.navigationBar.barTintColor = myColor;
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
}

#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [itemsArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
        v.layer.cornerRadius = 3.0f;
        v.layer.masksToBounds = YES;
    }
    
    [v fillViewWithObject:[itemsArray objectAtIndex:index]];
    //[v fillViewWithText:[capitionArray objectAtIndex:index]];
    //[v fillViewWithCaption:[capitionArray objectAtIndex:index] Nickname:[nicknameArray objectAtIndex:index] Time:nil Like:nil];
    [v fillViewWithCaption:[capitionArray objectAtIndex:index] Nickname:[nicknameArray objectAtIndex:index] PortraitImg:[portraitImgArray objectAtIndex:index] Time:nil Like:nil];
    
    return v;
    
    //return nil;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    
    //NSLog(@"self.collectionView.colWidth = %f".self.collectionView.colWidth.height);
    
    return [PSBroView heightForViewWithObject:[itemsArray objectAtIndex:index] withCapitionStr:[capitionArray objectAtIndex:index] inColumnWidth:self.collectionView.colWidth];
    
    //return 0.0;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    //    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You can do something when the user taps on a collectionViewCell here
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

//上传相关资料
- (void)uploadFindingsInfo {
    NSData *data = UIImagePNGRepresentation(sendingImg);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"finding_%@.png", dateStr];
    
    NSString *usernameStr = [NSString stringWithFormat:@"%@",[YDConfigurationHelper getStringValueForConfigurationKey:@"username"]];
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    dict = @{ @"username":usernameStr, @"text_comment":textComments,@"push_time":dateStr, @"likes_number":@"0"};
    
    NSMutableURLRequest *urlrequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://192.168.1.123:1200/uploadFindingInfo" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"myfile" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:urlrequest progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self showErrorWithMessage:@"连接失败，请重试"];
        } else {
            NSLog(@"finding上传成功！");
        }
    }];
    [uploadTask resume];
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
