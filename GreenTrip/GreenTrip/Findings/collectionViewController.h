//
//  collectionViewController.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/14.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PSBroView.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"

#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "sendMessagesViewController.h"

@interface collectionViewController : UIViewController <PSCollectionViewDelegate, PSCollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *itemsArray;
    NSMutableArray *itemsImgArray;     //用于存放实际图片
    
    NSMutableArray *findingIDArray;
    NSMutableArray *capitionArray;
    NSMutableArray *nicknameArray;
    NSMutableArray *portraitArray;
    NSMutableArray *portraitImgArray;  //用于存放实际头像图片
    
    NSMutableArray *likeNumArray;
    NSMutableArray *pushTimeArray;
    
    UIImage *sendingImg;
    NSString *textComments;
    
    NSInteger refreshTime;
    NSInteger refreshIndex;
    NSInteger loadMoreIndex;
    NSInteger loadMoreTime;
    
    NSMutableArray *PSBViewArray;
    
    NSInteger itemsImgNum;
    NSInteger porImgNum;
    
    UIActivityIndicatorView *activityIndicatorView;
    
}

@property (nonatomic, strong) PSCollectionView *collectionView;
@property (nonatomic, strong) NSString *getFindingsNum;

@end
