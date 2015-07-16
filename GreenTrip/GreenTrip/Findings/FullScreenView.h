//
//  FullScreenView.h
//  ImageSleek
//
//  Created by shuang on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullScreenViewDelegate;

@interface FullScreenView : UIScrollView
<UIScrollViewDelegate>

@property (nonatomic, weak)id<FullScreenViewDelegate> fullScreenDelegate;

// 默认大小 CGRectMake(0, 0, 320,480)
-(id)initWithImage:(UIImage*)image;

// 自定义大小
-(id)initWithImage:(UIImage*)image withFrame:(CGRect)frame;

@end

@protocol FullScreenViewDelegate <NSObject>

@optional

// 添加view动画开始加载
-(void)addAnimationFullScreentViewBegin;

// 添加view动画加载完成
-(void)addAnimationFullScreentViewFinished;

// 删除view动画开始加载
-(void)removeAnimationFullScreenViewBegin;

// 删除view动画加载完成
-(void)removeAnimationFullScreenViewFinished;

@end
