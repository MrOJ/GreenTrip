// TGRImageZoomTransition.m
//
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TGRImageViewController.h"

#define kScreenWidth  self.view.bounds.size.width
#define kScreenHeight  self.view.bounds.size.height
#define kMaxZoom 3.0

@interface TGRImageViewController () {
    CGFloat lastScale;
}

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
//@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation TGRImageViewController

- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    //self.imageView.frame = [UIScreen mainScreen].bounds;
    //self.scrollView.frame = [UIScreen mainScreen].bounds;
    self.imageView.image = self.image;
    
    [self.pinchGestureRecognizer addTarget:self action:@selector(scale:)];
    
    lastScale=1.0;
    
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.delaysContentTouches = NO;
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private methods


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

/*
- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}
*/
-(void)scale:(UIPinchGestureRecognizer*)sender {
    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.imageView setTransform:newTransform];
    lastScale = [sender scale];
    
}

@end
