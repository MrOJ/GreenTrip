//
//  PSBroView.h
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCollectionViewCell.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

#define myColor [UIColor colorWithRed:119.0 / 255.0f green:185.0 / 255.0f blue:67.0 / 255.0f alpha:1.0f]

@interface PSBroView : PSCollectionViewCell <UIViewControllerTransitioningDelegate>
{
    NSString *findingID;
    int i;
    NSInteger likeNum;
    
    //NSString *timeStr;
}

- (void)drawSubViews;

@end
