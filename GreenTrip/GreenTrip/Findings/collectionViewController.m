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
    
    /*
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"相机25x21px"] landscapeImagePhone:[UIImage imageNamed:@"相机25x21px"]  style:UIBarButtonItemStylePlain target:self action:@selector(openCamera:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头9x17px"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem  = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"绿出行圈";
    */
    //self.navigationItem.backBarButtonItem.title = @"返回";
    //self.navigationController.navigationBar.backItem.title = @"";
    //self.navigationController.navigationBar.backItem.title = @"返回";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    self.navigationItem.title = @"绿出行圈";
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 10 - 25, 14, 25, 21)];
    [cameraButton setImage:[UIImage imageNamed:@"相机25x21px"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:cameraButton];
    
    //将原先的bar隐藏起来
    UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] init];
    nilButton.title = @"";
    self.navigationItem.leftBarButtonItem = nilButton;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
    [backButton setImage:[UIImage imageNamed:@"箭头9x17px"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backButton];
    
    
    //头部主动刷新
    //[self.collectionView.header beginRefreshing];
    refreshTime    = 0;
    refreshIndex   = 0;
    loadMoreIndex  = 0;
    loadMoreTime   = 0;
    getFindingsNum = @"0";
    
    PSBViewArray = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    findingIDArray = [[NSMutableArray alloc] init];
    itemsArray     = [[NSMutableArray alloc] init];
    capitionArray  = [[NSMutableArray alloc] init];
    nicknameArray  = [[NSMutableArray alloc] init];
    portraitArray  = [[NSMutableArray alloc] init];
    likeNumArray   = [[NSMutableArray alloc] init];
    pushTimeArray  = [[NSMutableArray alloc] init];
    
    itemsImgArray    = [[NSMutableArray alloc] init];
    portraitImgArray = [[NSMutableArray alloc] init];
    
    itemsImgNum = 0;
    porImgNum   = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recNotification:) name:@"passValue" object:nil];
    
    [self.collectionView.legendHeader beginRefreshing];
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recNotification:(NSNotification *)notification {
    NSDictionary *getDic = [notification userInfo];
    textComments = [getDic objectForKey:@"message"];
    
    //上传图片至数据库
    [self uploadFindingsInfo];
    
    refreshTime += 1;
    
    //[self.collectionView reloadData];
    //[self.collectionView.header beginRefreshing];
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
        [manager GET:@"http://192.168.1.104:1200/syncFindingInfo" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSArray *getUsernameArray = [[NSArray alloc] init];
            getUsernameArray = [responseObject objectForKey:@"username_list"];
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            if ([stateStr isEqualToString:@"0"]) {
                
                if (itemsArray.count == 0) {
                    [findingIDArray addObjectsFromArray:[responseObject objectForKey:@"finding_ID_list"]];
                    [capitionArray addObjectsFromArray:[responseObject objectForKey:@"text_comment_list"]];
                    [nicknameArray addObjectsFromArray:[responseObject objectForKey:@"username_list"]];
                    [portraitArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                    [itemsArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                    [likeNumArray addObjectsFromArray:[responseObject objectForKey:@"likes_number_list"]];
                    [pushTimeArray addObjectsFromArray:[responseObject objectForKey:@"push_time_list"]];
                    
                    [itemsImgArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                    [portraitImgArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                    
                } else {
                    [findingIDArray insertObjects:[responseObject objectForKey:@"finding_ID_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [capitionArray insertObjects:[responseObject objectForKey:@"text_comment_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [nicknameArray insertObjects:[responseObject objectForKey:@"username_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [portraitArray insertObjects:[responseObject objectForKey:@"portrait_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [itemsArray insertObjects:[responseObject objectForKey:@"finding_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [likeNumArray insertObjects:[responseObject objectForKey:@"likes_number_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [pushTimeArray insertObjects:[responseObject objectForKey:@"push_time_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    
                    [itemsImgArray insertObjects:[responseObject objectForKey:@"finding_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                    [portraitImgArray insertObjects:[responseObject objectForKey:@"portrait_image_list"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, getUsernameArray.count)]];
                }
                
                getFindingsNum = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"findings_num"]];
                
                refreshIndex += getUsernameArray.count;
                
                //加载图片
                [self downloadImge:0];
                
            } else {
                NSLog(@"已无更多！");
                [self.collectionView.legendHeader endRefreshing];   //结束刷新
                [self.collectionView.legendFooter setHidden:NO];
            }
            
            refreshTime  += 1;
            
            //[self.collectionView reloadData];
            //[self.collectionView.legendHeader endRefreshing];   //结束刷新
            //[self.collectionView.legendFooter setHidden:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self showErrorWithMessage:@"连接失败，请重试"];
            [self.collectionView.legendHeader endRefreshing];
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
        [manager GET:@"http://192.168.1.104:1200/syncFindingInfo" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"GET --> %@", responseObject); //自动返回主线程
            
            NSArray *getUsernameArray = [[NSArray alloc] init];
            getUsernameArray = [responseObject objectForKey:@"username_list"];
            
            NSString *getState = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            NSLog(@"state = %@",getState);
            
            if ([getState isEqualToString:@"0"]) {
                NSLog(@"load more");
                [findingIDArray addObjectsFromArray:[responseObject objectForKey:@"finding_ID_list"]];
                [capitionArray addObjectsFromArray:[responseObject objectForKey:@"text_comment_list"]];
                [nicknameArray addObjectsFromArray:[responseObject objectForKey:@"username_list"]];
                [portraitArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                [itemsArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                [likeNumArray addObjectsFromArray:[responseObject objectForKey:@"likes_number_list"]];
                [pushTimeArray addObjectsFromArray:[responseObject objectForKey:@"push_time_list"]];
                
                [itemsImgArray addObjectsFromArray:[responseObject objectForKey:@"finding_image_list"]];
                [portraitImgArray addObjectsFromArray:[responseObject objectForKey:@"portrait_image_list"]];
                
                loadMoreIndex += getUsernameArray.count;
                //[self.collectionView reloadData];
                //[self.collectionView.legendFooter endRefreshing];   //结束刷新
                [self downloadImge:1];
                
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
            [self.collectionView.legendFooter endRefreshing];
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
    
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
        v.layer.cornerRadius = 3.0f;
        v.layer.masksToBounds = YES;
    }
    
    //NSLog(@"get iterm%@",[itemsArray objectAtIndex:index]);
    
    [v fillViewWithObject:[itemsImgArray objectAtIndex:index]];
    [v fillViewWithFinfdingID:[findingIDArray objectAtIndex:index]
                      Caption:[capitionArray objectAtIndex:index]
                     Nickname:[nicknameArray objectAtIndex:index]
                    PortraitImg:[portraitImgArray objectAtIndex:index]
                         Time:[pushTimeArray objectAtIndex:index]
                         Like:[likeNumArray objectAtIndex:index]];
    
    //PSBroView *v = (PSBroView *)[PSBViewArray objectAtIndex:index];
    
    return v;
    
    
    //return nil;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    
    //得到图片后直接导入
    
    return [PSBroView heightForViewWithObject:[itemsImgArray objectAtIndex:index] withCapitionStr:[capitionArray objectAtIndex:index] inColumnWidth:self.collectionView.colWidth];

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
    NSData *data = UIImageJPEGRepresentation(sendingImg, 0.001);
    
    // 设置图片时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr1 = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"finding_%@.png", dateStr1];
    
    // 设置时间格式
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr2 = [formatter2 stringFromDate:[NSDate date]];
    
    NSString *usernameStr = [NSString stringWithFormat:@"%@",[YDConfigurationHelper getStringValueForConfigurationKey:@"username"]];
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    dict = @{ @"username":usernameStr, @"text_comment":textComments,@"push_time":dateStr2, @"likes_number":@"0"};
    
    NSMutableURLRequest *urlrequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://192.168.1.104:1200/uploadFindingInfo" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            [self.collectionView reloadData];
            [self.collectionView.header beginRefreshing];
        }
    }];
    [uploadTask resume];
    
}

- (void)downloadImge:(NSInteger)flag
{
    //========================加载图片==========================
    for (NSString *imageName in itemsArray) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.104:1200/syncFindingImg?image=%@",imageName]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // progression tracking code
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                NSLog(@"图片加载出错error %@",error);
            } else {
                if (image) {
                    
                    //根据url获得当前的图片名称
                    NSString *urlStr = [NSString stringWithFormat:@"%@",imageURL];
                    NSRange range = [urlStr rangeOfString:@"="];
                    NSString *imageNameStr = [urlStr substringFromIndex:range.location + 1];
                    //NSLog(@"%@",imageNameStr);
                    NSLog(@"%ld",(long)[self getIndexFromArray:itemsImgArray originArray:itemsArray withTarget:imageNameStr]);
                    
                    NSInteger getIndex = [self getIndexFromArray:itemsImgArray originArray:itemsArray withTarget:imageNameStr];
                    if (getIndex > -1 ) {
                        [itemsImgArray replaceObjectAtIndex:getIndex withObject:image];
                    }
                    
                    itemsImgNum = [self calImageNumber:itemsImgArray];
                    
                    if (itemsImgNum + porImgNum == itemsArray.count * 2) {
                        //if (itemsImgNum == itemsArray.count) {
                        NSLog( @"图片和头像加载完毕！");
                        
                        [self.collectionView reloadData];
                        if (flag == 0) {
                            [self.collectionView.legendHeader endRefreshing];   //结束刷新
                        } else {
                            [self.collectionView.legendFooter endRefreshing];
                        }

                        [self.collectionView.legendFooter setHidden:NO];
                    }
                }
            }
        }];
    }
    //========================================================
    
    
    //========================加载头像==========================
    for (NSString *imageName in portraitArray) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.104:1200/syncportrait?image=%@",imageName]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // progression tracking code
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                NSLog(@"头像加载出错error %@",error);
            } else {
                if (image) {
                    NSLog(@"image = %@",image);
                    //根据url获得当前的图片名称
                    NSString *urlStr = [NSString stringWithFormat:@"%@",imageURL];
                    NSRange range = [urlStr rangeOfString:@"="];
                    NSString *imageNameStr = [urlStr substringFromIndex:range.location + 1];
                    //NSLog(@"%@",imageNameStr);
                    //NSLog(@"%ld",(long)[self getIndexFromArray:itemsArray withTarget:imageNameStr]);
                    [portraitImgArray replaceObjectAtIndex:[self getIndexFromArray:portraitArray originArray:portraitArray withTarget:imageNameStr] withObject:image];
                    
                    NSInteger getIndex = [self getIndexFromArray:portraitImgArray originArray:portraitArray withTarget:imageNameStr];
                    if (getIndex > -1 ) {
                        [portraitImgArray replaceObjectAtIndex:getIndex withObject:image];
                    }
                    
                    porImgNum = [self calImageNumber:portraitImgArray];
                    
                    if (itemsImgNum + porImgNum == portraitImgArray.count * 2) {
                        NSLog( @"图片和头像加载完毕！");
                        
                        [self.collectionView reloadData];
                        if (flag == 0) {
                            [self.collectionView.legendHeader endRefreshing];   //结束刷新
                        } else {
                            [self.collectionView.legendFooter endRefreshing];
                        }
                        [self.collectionView.legendFooter setHidden:NO];
                    }
                }
            }
        }];
    }
    //========================================================
}

//根据数组中的值获得索引
- (NSInteger)getIndexFromArray:(NSMutableArray *)array originArray:(NSMutableArray*)oriArray withTarget:(NSString *)target
{
    for (int i=0; i < array.count; i++) {
        if ([array[i] isKindOfClass:[NSString class]] && [oriArray[i] isKindOfClass:[NSString class]]) {
            if ([array[i] isEqualToString:target]) {
                return i;
            }
        }
    }
    
    return -1;
}

//计算数组中UIImage的格式
- (NSInteger)calImageNumber:(NSMutableArray *)array
{
    int i = 0;
    for (id oj in array) {
        if ([oj isKindOfClass:[UIImage class]]) {
            i++;
        }
    }
    
    return i;
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
