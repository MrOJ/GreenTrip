//
//  customActionSheet.h
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/21.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol doneSelect <NSObject>

-(void)done;

@end

@interface customActionSheet : UIView
{
    UIToolbar* toolBar;
    
}

-(id)initWithView:(UIView *)view AndHeight:(float)height;

-(void)showInView:(UIView *)view;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,unsafe_unretained) id<doneSelect> doneDelegate;

@end
