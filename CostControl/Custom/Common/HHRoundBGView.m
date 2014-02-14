//
//  HHRoundBGView.m
//  Huhoo
//
//  Created by Sasori on 13-6-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHRoundBGView.h"
#import "QuartzCore/QuartzCore.h"

@implementation HHRoundBGView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	self.layer.cornerRadius = 10.0;
	self.clipsToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];
}


@end
