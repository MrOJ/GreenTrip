//
// PSCollectionViewCell.h
//
// Copyright (c) 2012 Peter Shih (http://petershih.com)
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

#import <UIKit/UIKit.h>

@interface PSCollectionViewCell : UIView

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *textStr;

@property (nonatomic, strong) NSString *captionStr;
@property (nonatomic, strong) NSString *nicknameStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *likeStr;
@property (nonatomic, strong) NSString *findingIDStr;

@property (nonatomic, strong)UIImage *portraitImage;

- (void)prepareForReuse;
- (void)fillViewWithObject:(id)object;
- (void)fillViewWithText:(id)str;
- (void)fillViewWithFinfdingID:(id)ID Caption:(id)caption Nickname:(id)nickname PortraitImg:(id)portrait Time:(id)time Like:(id)like;
+ (CGFloat)heightForViewWithObject:(id)object withCapitionStr:(NSString *)str inColumnWidth:(CGFloat)columnWidth;
//- (CGFloat)heightForViewWithObject:(id)object withCapitionStr:(NSString *)str inColumnWidth:(CGFloat)columnWidth;

@end
