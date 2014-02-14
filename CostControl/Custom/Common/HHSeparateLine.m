//
//  HHSeparateLine.m
//  Huhoo
//
//  Created by Sasori on 13-4-24.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHSeparateLine.h"
#import "HHUtils.h"

@implementation HHSeparateLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	self.backgroundColor = [UIColor clearColor];
	_topColor = [HHUtils hexStringToColor:@"#CDCDCD"];
	_botColor = [HHUtils hexStringToColor:@"#FFFFFF"];
}

- (void)setTopColor:(UIColor *)topColor
{
	_topColor = topColor;
	[self setNeedsDisplay];
}

- (void)setBotColor:(UIColor *)botColor
{
	_botColor = botColor;
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	CGContextSetShouldAntialias(ctx, NO);
	UIColor* c = self.topColor;
	CGContextSetStrokeColorWithColor(ctx, c.CGColor);
	CGContextSetLineWidth(ctx, rect.size.height/2);
	CGContextMoveToPoint(ctx, 0, 0);
	CGContextAddLineToPoint(ctx, rect.size.width, 0);
	CGContextStrokePath(ctx);
	
	c = self.botColor;
	CGContextSetStrokeColorWithColor(ctx, c.CGColor);
	CGContextSetLineWidth(ctx, rect.size.height/2);
	CGContextMoveToPoint(ctx, 0, rect.size.height/2);
	CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height/2);
	CGContextStrokePath(ctx);
	
	UIGraphicsPopContext();
}


@end
