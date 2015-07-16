//
//  FullScreenView.m
//  ImageSleek
//
//  Created by shuang on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FullScreenView.h"
#import "QuartzCore/QuartzCore.h"

#define Default_MainFrame   CGRectMake(0, 0, 320,460)

#define CAAnimation_FullView_Key            @"CAAnimation_FullView_Key"
#define CAAnimation_Add_FullView_Key        @"CAAnimation_Add_FullView_Key"
#define CAAnimation_Remove_FullView_Key     @"CAAnimation_Remove_FullView_Key"

@interface FullScreenView ()
@property (nonatomic, strong)UIImageView  *m_imageView;

//-(void)initImageViewWithImage:(UIImage*)image;
-(void)initFullImageViewWithImage:(UIImage*)image;
-(CGRect)imageRectWithImageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;
- (void)animatedWithAddView:(BOOL)isAddView;
@end

@implementation FullScreenView
@synthesize m_imageView;
@synthesize fullScreenDelegate;


-(id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image withFrame:Default_MainFrame];
}

-(id)initWithImage:(UIImage*)image withFrame:(CGRect)frame
{
    if (self = [super init])
    {
        self.frame = frame;
        // scroll view init
        self.scrollEnabled = YES;
        self.delegate = self;
        self.bouncesZoom = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.showsHorizontalScrollIndicator    = NO;
        self.showsVerticalScrollIndicator      = NO;
        self.transform = CGAffineTransformIdentity;
        self.contentOffset = CGPointZero;//CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
        self.contentMode = UIViewContentModeCenter;
        self.contentSize = m_imageView.frame.size;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;
        
        //[self initImageViewWithImage:image];
        [self initFullImageViewWithImage:image];
        
        [self addSubview:m_imageView];
        // 手势
        UITapGestureRecognizer *singleTapGestureRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]; 
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapGestureRecognizer];
        
        // animated
        [self animatedWithAddView:YES];
    }
    
    return self;
}

-(void)initFullImageViewWithImage:(UIImage*)image
{
    // imageView init
    self.m_imageView  = [[UIImageView alloc] initWithImage:image];
    
    CGFloat imageWidth  = (image.size.width);///2.0f;//除以2.0f是高清的图片
    CGFloat imageHeight = (image.size.height);///2.0f;
    
    m_imageView.frame = [self imageRectWithImageWidth:imageWidth imageHeight:imageHeight];
    m_imageView.contentMode = UIViewContentModeScaleAspectFit;
    m_imageView.userInteractionEnabled = YES;
}

-(CGRect)imageRectWithImageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight
{
    CGRect rectTemp = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
    
    CGFloat imageAndBoundsWidth  = imageWidth/self.bounds.size.width;
    CGFloat imageAndBoundsHeight = imageHeight/self.bounds.size.height;
    
    if (imageAndBoundsWidth > 1 || imageAndBoundsHeight > 1)
    {
        // 设置图片缩放比例
        self.maximumZoomScale = (imageAndBoundsWidth>imageAndBoundsHeight)?imageAndBoundsWidth:imageAndBoundsHeight + 3.0f;
        
        // 需要按比例缩放
        if (imageAndBoundsWidth>imageAndBoundsHeight)
        {
            // 按照宽度缩放
            if (imageWidth > self.bounds.size.width)
            {
                rectTemp.origin.x = 0.0f;
                rectTemp.size.width = self.bounds.size.width;
                rectTemp.size.height = self.bounds.size.width*imageHeight/imageWidth;
            }
        }
        else
        {
            // 按照高度缩放
            if (imageHeight > self.bounds.size.height)
            {
                rectTemp.origin.y = 0.0f;
                rectTemp.size.height = self.bounds.size.height;
                rectTemp.size.width = self.bounds.size.height*imageWidth/imageHeight;
            }   
        }
    }
    
    // 调整起始坐标位置
    if (rectTemp.size.width < self.bounds.size.width)
    {
        rectTemp.origin.x = (self.bounds.size.width-rectTemp.size.width)/2.0f;
    }
    
    if (rectTemp.size.height < self.bounds.size.height)
    {
        rectTemp.origin.y = (self.bounds.size.height-rectTemp.size.height)/2.0f;
    }
    
    return rectTemp;
}

//-(void)initImageViewWithImage:(UIImage*)image
//{
//    // imageView init
//    self.m_imageView  = [[[UIImageView alloc] initWithImage:image] autorelease];
//    CGFloat xFloat = 0.0f;
//    CGFloat yFloat = 0.0f;
//    CGFloat imageWidth  = (image.size.width)/2.0f;
//    CGFloat imageHeight = (image.size.height)/2.0f;
//    CGRect rectTemp = self.bounds;
//    if (imageWidth < rectTemp.size.width)
//    {
//        xFloat = (rectTemp.size.width-imageWidth)/2.0f;
//    }
//    
//    if (imageHeight < rectTemp.size.height)
//    {
//        yFloat = (rectTemp.size.height-imageHeight)/2.0f;
//    }
//    
//    m_imageView.frame = CGRectMake(xFloat, yFloat, imageWidth, imageHeight);
//    m_imageView.contentMode = UIViewContentModeScaleAspectFit;
//    m_imageView.userInteractionEnabled = YES;
//}

-(void)dealloc
{
    fullScreenDelegate = nil;
    
}

#pragma mark TapDetectingImageViewDelegate methods  

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
	// single tap does nothing for now  
    
    [self animatedWithAddView:NO];
}  

#pragma mark - scroll delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //NSLog(@"viewForZoomingInScrollView");
    
    return m_imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidZoom");
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2.0f : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2.0f : ycenter;
    
    m_imageView.center = CGPointMake(xcenter, ycenter);
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
//{
//    NSLog(@"%f",view.frame.size.width);
//    NSLog(@"%f",view.frame.size.height);
//    NSLog(@"%f",view.frame.origin.x);
//    NSLog(@"%f",view.frame.origin.y);
//    
//    NSLog(@"%f",scrollView.frame.size.width);
//    NSLog(@"%f",scrollView.frame.size.height);
//    NSLog(@"%f",scrollView.frame.origin.x);
//    NSLog(@"%f",scrollView.frame.origin.y);
//    
//    NSLog(@"%f",scale);

//    
//    CGRect rectTemp = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
//    
//    if ((view.frame.size.width) < self.bounds.size.width)
//    {
//        rectTemp.origin.x = (self.bounds.size.width-(view.frame.size.width))/2;
//    }
//    else
//    {
//        rectTemp.origin.x = 0.0f;
//    }
//    
//    if ((view.frame.size.height) < self.bounds.size.height)
//    {
//        rectTemp.origin.y = (self.bounds.size.height-(view.frame.size.height))/2;
//    }
//    else
//    {
//        rectTemp.origin.y = 0.0f;
//    }
//    
//    view.frame = rectTemp;
//}

#pragma mark - animated
#pragma mark - 图片滑动的demo
- (void)animatedWithAddView:(BOOL)isAddView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2f;
    NSMutableArray *values = [NSMutableArray array];
    
    if (!isAddView)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        
        
        [animation setValue:CAAnimation_Remove_FullView_Key forKey:CAAnimation_FullView_Key];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        [animation setValue:CAAnimation_Add_FullView_Key forKey:CAAnimation_FullView_Key];
    }
    
    animation.delegate = self;
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    CAKeyframeAnimation* animation = (CAKeyframeAnimation*)anim;
    //NSLog(@"value %@",[animation valueForKey:CAAnimation_FullView_Key]);
    if ([(NSString*)[animation valueForKey:CAAnimation_FullView_Key] isEqualToString:CAAnimation_Remove_FullView_Key])
    {
        //NSLog(@"remove View begin");
        if (fullScreenDelegate && [fullScreenDelegate respondsToSelector:@selector(removeAnimationFullScreenViewBegin)])
        {
            [fullScreenDelegate removeAnimationFullScreenViewBegin];
            
        }
        
        return;
    }
    
    if ([(NSString*)[animation valueForKey:CAAnimation_FullView_Key] isEqualToString:CAAnimation_Add_FullView_Key])
    {
        //NSLog(@"add View begin");
        if (fullScreenDelegate && [fullScreenDelegate respondsToSelector:@selector(addAnimationFullScreentViewBegin)])
        {
            [fullScreenDelegate addAnimationFullScreentViewBegin];
        }
        
        return;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAKeyframeAnimation* animation = (CAKeyframeAnimation*)anim;
    //NSLog(@"value %@",[animation valueForKey:CAAnimation_FullView_Key]);
    if ([(NSString*)[animation valueForKey:CAAnimation_FullView_Key] isEqualToString:CAAnimation_Remove_FullView_Key])
    {
        //NSLog(@"remove View finished");
        UIViewController *VC = [self findViewController:self];
        
        [self removeFromSuperview];
        
        
        [VC dismissViewControllerAnimated:NO completion:^{
            
        }];
        
        if (fullScreenDelegate && [fullScreenDelegate respondsToSelector:@selector(removeAnimationFullScreenViewFinished)])
        {
            [fullScreenDelegate removeAnimationFullScreenViewFinished];

        }
        
        return;
    }
    
    if ([(NSString*)[animation valueForKey:CAAnimation_FullView_Key] isEqualToString:CAAnimation_Add_FullView_Key])
    {
        //NSLog(@"add View finished");
        if (fullScreenDelegate && [fullScreenDelegate respondsToSelector:@selector(addAnimationFullScreentViewFinished)])
        {
            [fullScreenDelegate addAnimationFullScreentViewFinished];
        }
        
        return;
    }
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

@end
