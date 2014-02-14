//
//  HHGlowTitleButton.h
//  Huhoo
//
//  Created by Jason Chong on 13-5-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRSGlowLabel.h"

@protocol HHGlowTitleButtonDelegate;

@interface HHGlowTitleButton : UIView

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) RRSGlowLabel* glowLabel;

@property (nonatomic, assign) CGSize glowOffset;
@property (nonatomic, assign) CGFloat glowAmount;
@property (nonatomic, strong) UIColor *glowColor;

@property (nonatomic, weak) id<HHGlowTitleButtonDelegate> delegate;

@end

@protocol HHGlowTitleButtonDelegate <NSObject>
@optional
- (void) touchUpInside:(HHGlowTitleButton*)glowTitleButton;
- (void) touchDown:(HHGlowTitleButton*)glowTitleButton;
@end
