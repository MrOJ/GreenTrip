//
//  textBikeOnlyRoutesView.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/13.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "textBikeOnlyRoutesView.h"

@implementation textBikeOnlyRoutesView
@synthesize dragEnable;

- (id)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self) {
    self.backgroundColor = [UIColor whiteColor];
    initPoint = self.center;                     //获取起始位置
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //self.layer.shadowOffset = CGSizeMake(0, 2);
    //self.layer.shadowOpacity = 1;
    //self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    //添加点击响应
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    //[self showOnTheView];
    
}
return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    //beginPoint = self.center;
    //NSLog(@"beginPoint = %f",beginPoint.y);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    //float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    //NSLog(@"%f",offsetY);
    if (offsetY < 0) {
        isUp = TRUE;
    } else {
        isUp = FALSE;
    }
    
    CGPoint current = CGPointMake(self.center.x, self.center.y + offsetY);
    
    //防止其他区域滑动
    if (current.y < initPoint.y && current.y > self.superview.center.y) {
        self.center = CGPointMake(self.center.x, self.center.y + offsetY);
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    
    //NSLog(@"self.center.y = %f", self.center.y);
    //NSLog(@"currentPage = %ld", (long)currentPage);
    
    if (isUp == TRUE) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y);
            
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"下拉箭头19x11px"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"上拉箭头19x11px"];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    if (self.center.y == initPoint.y) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"下拉箭头19x11px"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"上拉箭头19x11px"];
    }
    
}


//实现手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    CGPoint point = [touch locationInView:self];
    
    // 判断是不是点击顶部的brief栏，如果不是,则tap手势不响应事件
    if ((point.y >= 0.0 && point.y <= 90.0)) {
        return YES;
    }
    //self.scrollEnabled = YES;
    return NO;
    
}

- (void)buildingView
{
    
}

//时间转换
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    //NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours < 1) {
        return [NSString stringWithFormat:@"%ld分钟", (long)minutes];
    } else {
        return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hours, (long)minutes];
    }
    
}

@end
