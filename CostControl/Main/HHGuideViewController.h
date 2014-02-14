//
//  HHGuideViewController.h
//  Huhoo
//
//  Created by Jason Chong on 13-5-21.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHGuideViewControllerDelegate;

@interface HHGuideViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) id<HHGuideViewControllerDelegate> delegate;

@end

@protocol HHGuideViewControllerDelegate <NSObject>
@optional
- (void)guideViewControllerHidden:(HHGuideViewController*)guideViewController;

@end
