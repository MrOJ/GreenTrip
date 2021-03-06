//
// PSCollectionViewCell.m
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

#import "PSCollectionViewCell.h"

@interface PSCollectionViewCell ()

@end

@implementation PSCollectionViewCell

@synthesize
object = _object;

@synthesize textStr;
@synthesize captionStr;
@synthesize nicknameStr;
@synthesize likeStr;
@synthesize timeStr;
@synthesize portraitImage;
@synthesize findingIDStr;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)prepareForReuse {
}

- (void)fillViewWithObject:(id)object {
    self.object = object;
}

- (void)fillViewWithText:(id)str {
    self.textStr = str;
}

- (void)fillViewWithFinfdingID:(id)ID Caption:(id)caption Nickname:(id)nickname PortraitImg:(id)portrait Time:(id)time Like:(id)like {
    self.findingIDStr = ID;
    self.captionStr = caption;
    self.nicknameStr = nickname;
    self.timeStr = time;
    self.likeStr = like;
    self.portraitImage = portrait;
}

+ (CGFloat)heightForViewWithObject:(id)object withCapitionStr:(NSString *)str inColumnWidth:(CGFloat)columnWidth {
//- (CGFloat)heightForViewWithObject:(id)object withCapitionStr:(NSString *)str inColumnWidth:(CGFloat)columnWidth {
    return 0.0;
}

@end
