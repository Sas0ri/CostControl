//
//  HHGlowTitleButton.m
//  Huhoo
//
//  Created by Jason Chong on 13-5-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHGlowTitleButton.h"
#import <QuartzCore/QuartzCore.h>

@interface HHGlowTitleButton()



@end

@implementation HHGlowTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.glowOffset = CGSizeMake(0.0, 0.0);
        self.glowAmount = 0.0;
        self.glowColor = [UIColor clearColor];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		
		// Register for touch events
		[self.button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
		[self.button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
		[self.button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
		[self.button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
        
        self.glowLabel = [[RRSGlowLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.glowLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.glowLabel.layer.shadowOffset = CGSizeMake(1, 1);
        self.glowLabel.layer.shadowOpacity = 0.5;
        self.glowLabel.layer.shadowRadius = 1;
        
        self.glowLabel.textColor = [UIColor whiteColor];
        self.glowColor = [UIColor whiteColor];
        self.glowAmount = 10.0;
        self.glowLabel.textAlignment = NSTextAlignmentCenter;
        [self.button addSubview:self.glowLabel];
        
        
        [self addSubview:self.button];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setGlowColor:(UIColor *)glowColor
{
    _glowColor = glowColor;
    self.glowLabel.glowColor = glowColor;
}

- (void)setGlowOffset:(CGSize)glowOffset
{
    _glowOffset = glowOffset;
    self.glowLabel.glowOffset = glowOffset;
}

- (void)touchDownAction:(UIButton*)button
{
    self.glowLabel.glowAmount = self.glowAmount;
    [self.glowLabel setNeedsDisplay];
	if ([self.delegate respondsToSelector:@selector(touchDown:)])
		[self.delegate touchDown:self];
}

- (void)touchUpInsideAction:(UIButton*)button
{
    self.glowLabel.glowAmount = 0;
    [self.glowLabel setNeedsDisplay];
	if ([self.delegate respondsToSelector:@selector(touchUpInside:)])
		[self.delegate touchUpInside:self];
}

- (void)otherTouchesAction:(UIButton*)button
{
	self.glowLabel.glowAmount = 0;
    [self.glowLabel setNeedsDisplay];
}


@end
