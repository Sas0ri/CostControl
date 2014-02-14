//
//  HHTouchView.m
//  Huhoo
//
//  Created by Sasori on 13-4-2.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHTouchView.h"

@implementation HHTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.delegate didTouchInView:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
