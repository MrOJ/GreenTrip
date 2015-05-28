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
    NSMutableArray *capitionArray;
    NSMutableArray *nicknameArray;
    NSMutableArray *portraitImgArray;
    
    UIImage *sendingImg;
    NSString *textComments;

}

@property (nonatomic, strong) PSCollectionView *collectionView;

@end
