///  ARAnnotation.m
//  ARBusSearch
//
//  Created by Mr.OJ on 14-2-12.
//  Copyright (c) 2014年 Mr.OJ. All rights reserved.
//

#import "ARAnnotation.h"
#import "ARCoordinate.h"

#define ANNOTATION_WIDTH 150
#define ANNOTATION_HEIGHT 200

@implementation ARAnnotation

- (id)initWithCoordinate:(ARCoordinate *)coordinate
{
    //创建两个标签（一个用于名字，一个用于位置）
    CGRect annotationFrame = CGRectMake(0, 0, ANNOTATION_WIDTH, ANNOTATION_HEIGHT);
    
    if (self = [super initWithFrame:annotationFrame]) {
        
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        //[labelView setBackgroundColor:[UIColor whiteColor]];
        //设置圆形边角
        labelView.layer.cornerRadius = 5.0;
        labelView.layer.masksToBounds = YES;

        //设置背景透明度
        UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        [labelView setBackgroundColor:tintColor];
        
        [self addSubview:labelView];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(0, 0, 50, 50)];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"公交图标41x42px"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [labelView addSubview:shareButton];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ANNOTATION_WIDTH, 20.0)];
        
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = coordinate.name;
        [nameLabel sizeToFit];
        [nameLabel setFrame:CGRectMake(50, 0, nameLabel.bounds.size.width + 8.0, nameLabel.bounds.size.height + 8.0)];
        [labelView addSubview:nameLabel];
        
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ANNOTATION_WIDTH, 20.0)];
        placeLabel.backgroundColor = [UIColor clearColor];
        placeLabel.textAlignment = NSTextAlignmentCenter;
        placeLabel.font = [UIFont systemFontOfSize:10.0f];
        placeLabel.text = coordinate.place;
        [placeLabel sizeToFit];
        [placeLabel setFrame:CGRectMake(50, 25, placeLabel.bounds.size.width + 8.0, placeLabel.bounds.size.height + 8.0)];
        [labelView addSubview:placeLabel];
        
        
		//[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (IBAction)shareButtonClicked:(id)sender{
    NSLog(@"Hello");
}
@end
