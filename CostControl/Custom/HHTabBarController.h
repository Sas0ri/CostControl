//
//  HHTabBarController.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface HHTabBarController : UIViewController

@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) NSArray* views;
@property (nonatomic) NSInteger currentViewIndex;

- (void)initWithTitles:(NSArray*)titles views:(NSArray*)views viewFrame:(CGRect)viewFrame;
- (void)setCurrentViewIndex:(NSInteger)index animated:(BOOL)animated;
- (void)handleCurrentViewChanged:(NSInteger)index;

@end
