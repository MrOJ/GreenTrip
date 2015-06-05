//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"

#define MARGIN 0.0

@interface PSBroView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *imageButton;

@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) UIView *profileView;
@property (nonatomic, strong) UIImageView *profileImge;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *releaseTime;
@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation PSBroView

@synthesize
imageView = _imageView,
imageButton = _imageButton,
captionLabel = _captionLabel,
profileView = _profileView,
profileImge = _profileImge,
nickname = _nickname,
releaseTime = _releaseTime,
likeButton = _likeButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //self.imageView.clipsToBounds = YES;
        //[self addSubview:self.imageView];
        
        self.imageButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.imageButton.clipsToBounds = YES;
        [self addSubview:self.imageButton];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.captionLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.captionLabel.numberOfLines = 0;
        [self addSubview:self.captionLabel];
        
        self.profileView = [[UIView alloc] initWithFrame:CGRectZero];
        self.profileView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.profileView];
        
        self.profileImge =  [[UIImageView alloc] initWithFrame:CGRectZero];
        self.nickname = [[UILabel alloc] init];
        self.releaseTime = [[UILabel alloc] init];
        
        //设置头像
        self.profileImge.frame = CGRectMake(12, 17, 31, 31);
        //self.profileImge.image = [UIImage imageNamed:@"proxy.png"];
        self.profileImge.layer.masksToBounds = YES;
        self.profileImge.layer.borderColor = myColor.CGColor;
        self.profileImge.layer.cornerRadius = 31 / 2;
        [self.profileView addSubview:self.profileImge];
        
        //设置发布时间
        //self.releaseTime.frame = CGRectMake(50, 19, self.frame.size.width - 50 - 23, 15);
        self.releaseTime.text = @"1小时前";
        self.releaseTime.textColor = [UIColor lightGrayColor];
        self.releaseTime.font = [UIFont systemFontOfSize:11.0f];
        [self.profileView addSubview:self.releaseTime];
        
        //设置昵称
        //NSLog(@"%f",self.frame.size.width);
        //self.nickname.frame = CGRectMake(50, 34, self.frame.size.width - 50 - 23, 15);
        //self.nickname.text = @"MrOJ";
        self.nickname.textColor = [UIColor blackColor];
        self.nickname.font = [UIFont systemFontOfSize:12.0f];
        [self.profileView addSubview:self.nickname];
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;

    
    // Image
    CGFloat objectWidth = self.imageView.image.size.width;
    CGFloat objectHeight = self.imageView.image.size.height;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    self.imageButton.frame = self.imageView.frame;
    [self.imageButton addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.imageButton addSubview:self.imageView];
    
    // Label
    CGSize labelSize = CGSizeZero;
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:self.captionLabel.text
     attributes:@
     {
     NSFontAttributeName: self.captionLabel.font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, INT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    labelSize = rect.size;
    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
    self.captionLabel.frame = CGRectMake(12, top+12, self.frame.size.width - 24, labelSize.height);
    
    //设置个人信息
    self.profileView.frame = CGRectMake(0, top + self.captionLabel.frame.size.height + 12, self.frame.size.width, 70);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 9, self.frame.size.width, 0.5)];
    line.backgroundColor = myColor;
    [self.profileView addSubview:line];
    
    self.releaseTime.frame = CGRectMake(50, 19, self.frame.size.width - 50 - 38, 15);
    self.nickname.frame = CGRectMake(50, 34, self.frame.size.width - 50 - 38, 15);
    
    self.likeButton.frame = CGRectMake(self.frame.size.width - 50, self.profileView.frame.size.height - 36, 48, 14);
    //self.likeButton.backgroundColor = [UIColor redColor];
    [self.likeButton setImage:[UIImage imageNamed:@"12x10px未激活"] forState:UIControlStateNormal];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0, 0, 8.0)];
    self.likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.likeButton setTitle:@"99+" forState:UIControlStateNormal];
    //[self.likeButton sizeToFit];
    [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0.0)];
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(pressLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.profileView addSubview:self.likeButton];

}

- (void)openImage:(id)sender {
    NSLog(@"open");
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[self.imageButton imageForState:UIControlStateNormal]];
    viewController.view.frame = [UIScreen mainScreen].bounds;
    viewController.transitioningDelegate = self;
    
    UIViewController *VC = [self findViewController:self];
    
    [VC presentViewController:viewController animated:YES completion:nil];
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (void)pressLikeButton:(id)sender {
    NSLog(@"like!");
    
}

- (void)fillViewWithObject:(id)image {
    [super fillViewWithObject:image];
    
    /*
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@", [object objectForKey:@"hash"], [object objectForKey:@"ext"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
    
    self.captionLabel.text = [object objectForKey:@"title"];
    */
    
    if ([image isKindOfClass:[NSString class]]) {
        self.imageView.image = [UIImage imageNamed:image];
        [self.imageButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    } else if ([image isKindOfClass:[UIImage class]]) {
        self.imageView.image = image;
        [self.imageButton setImage:image forState:UIControlStateNormal];
    }
    //self.captionLabel.text = str;
    
}

- (void)fillViewWithText:(id)str {
    [super fillViewWithText:str];
    
    self.captionLabel.text = str;
    
}

- (void)fillViewWithCaption:(id)caption Nickname:(id)nickname PortraitImg:(id)portrait Time:(id)time Like:(id)like {
    [super fillViewWithCaption:caption Nickname:nickname PortraitImg:portrait Time:time Like:like];
    
    self.captionLabel.text = caption;
    self.nickname.text = nickname;

    
    if ([portrait isKindOfClass:[NSString class]]) {
        self.profileImge.image = [UIImage imageNamed:portrait];
    } else {
        self.profileImge.image = portrait;
    }
}

+ (CGFloat)heightForViewWithObject:(id)object withCapitionStr:(NSString *)str inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    UIImage *img = [[UIImage alloc] init];
    if ([object isKindOfClass:[NSString class]]) {
        img = [UIImage imageNamed:object];
    } else if ([object isKindOfClass:[UIImage class]]) {
        img = object;
    }
    // Image
    //CGFloat objectWidth = [[object objectForKey:@"width"] floatValue];
    //CGFloat objectHeight = [[object objectForKey:@"height"] floatValue];
    CGFloat objectWidth = img.size.width;
    CGFloat objectHeight = img.size.height;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    NSString *caption = str;
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:12.0];
    
    //labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:caption
     attributes:@
     {
     NSFontAttributeName: labelFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, INT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    labelSize = rect.size;
    
    //height += self->captionLabel.frame.size.height;
    height += rect.size.height;
    
    height += 70;
    
    return height;
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
    }
    return nil;
}

@end
