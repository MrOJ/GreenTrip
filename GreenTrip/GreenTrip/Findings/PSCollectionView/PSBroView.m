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
@property (nonatomic, strong) UILabel *captionLabel;

@end

@implementation PSBroView

@synthesize
imageView = _imageView,
captionLabel = _captionLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.captionLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.captionLabel.numberOfLines = 0;
        [self addSubview:self.captionLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;

    
    // Image
    //CGFloat objectWidth = [[self.object objectForKey:@"width"] floatValue];
    //CGFloat objectHeight = [[self.object objectForKey:@"height"] floatValue];
    CGFloat objectWidth = self.imageView.image.size.width;
    CGFloat objectHeight = self.imageView.image.size.height;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    // Label
    CGSize labelSize = CGSizeZero;
    //labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
    
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
    
    self.captionLabel.frame = CGRectMake(left, top, labelSize.width, labelSize.height);
}

- (void)fillViewWithObject:(id)str {
    [super fillViewWithObject:str];
    
    /*
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@", [object objectForKey:@"hash"], [object objectForKey:@"ext"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
    
    self.captionLabel.text = [object objectForKey:@"title"];
    */
    
    self.imageView.image = [UIImage imageNamed:str];
    self.captionLabel.text = str;
    
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    UIImage *img = [UIImage imageNamed:object];
    
    // Image
    //CGFloat objectWidth = [[object objectForKey:@"width"] floatValue];
    //CGFloat objectHeight = [[object objectForKey:@"height"] floatValue];
    CGFloat objectWidth = img.size.width;
    CGFloat objectHeight = img.size.height;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    NSString *caption = object;
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
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
    
    height += labelSize.height;
    
    height += MARGIN;
    
    return height;
}

@end
