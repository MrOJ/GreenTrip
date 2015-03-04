//
//  customActionSheet.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/21.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "customActionSheet.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define ANIMATE_DURATION                        0.25f

@implementation customActionSheet

-(id)initWithView:(UIView *)view AndHeight:(float)height{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        //        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成ActionSheetView
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 200), 320, height)];
        //self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        label.text = @"确认具体地址";
        [topView addSubview:label];
        
        UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.backGroundView.bounds.size.height - 44,  [UIScreen mainScreen].bounds.size.width - 20 * 2, 30)];
        [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
        [bottomButton setBackgroundColor:[UIColor lightGrayColor]];
        [bottomButton addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
        
        //给ActionSheetView添加响应事件(如果不加响应事件则传过来的view不显示)
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        tapGesture1.cancelsTouchesInView = NO;
        [self.backGroundView addGestureRecognizer:tapGesture1];
        
        
        [self addSubview:self.backGroundView];
        //[self.backGroundView addSubview:toolBar];
        [self.backGroundView addSubview:view];
        [self.backGroundView addSubview:topView];
        [self.backGroundView addSubview:bottomButton];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height)];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
}

- (void)tappedBackGroundView
{
    //
}

-(void)done{
    
    
    [self.doneDelegate done];
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

