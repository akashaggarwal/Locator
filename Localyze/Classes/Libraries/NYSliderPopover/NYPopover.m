//
//  NYPopover.m
//  NYReader
//
//  Created by Cassius Pacheco on 21/12/12.
//  Copyright (c) 2013 Nyvra Software. All rights reserved.
//
/*
 Copyright (c) 2012 Nyvra Software <nyvra@nyvra.net>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "NYPopover.h"

@implementation NYPopover

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!_textLabel) {
        UIImageView *imgBkg = [[UIImageView alloc] initWithFrame:self.bounds];
        imgBkg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imgBkg.image = [[UIImage imageNamed:@"slider-percent-bottom"] resizableImageWithCapInsets:(UIEdgeInsets){11, 10, 8, 35}];
        [self addSubview:imgBkg];
        
        UIImage *imgArrow = [UIImage imageNamed:@"slider-percent-arrow"];
        UIImageView *imgArrowV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), imgArrow.size.height)];
        imgArrowV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imgArrowV.contentMode = UIViewContentModeCenter;
        imgArrowV.image = imgArrow;
        [self addSubview:imgArrowV];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.37f alpha:1.00f];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = (CGSize){0,0.5};
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.opaque = NO;
        self.clipsToBounds = NO;
        
        [self addSubview:self.textLabel];
    }
    
    CGFloat y = (frame.size.height - 26) / 3;
    
    if (frame.size.height < 38)
        y = 0;
    
    self.textLabel.frame = CGRectMake(0, y, frame.size.width, 22);
}


@end
