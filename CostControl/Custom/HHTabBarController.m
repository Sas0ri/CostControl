//
//  HHTabBarController.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHTabBarController.h"

@interface HHTabBarController ()

@end

@implementation HHTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.clipsToBounds = YES;
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithTitles:(NSArray *)titles views:(NSArray *)views viewFrame:(CGRect)viewFrame
{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    [self.segmentedControl setFrame:CGRectMake(0, 0, 320, 44)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setTag:titles.count + 1];
    [self.segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [self.view addSubview:self.segmentedControl];
    self.currentViewIndex = -1;
    self.views = views;
    
    CGRect tempViewFrame = viewFrame;
    tempViewFrame.origin.y = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height;
    tempViewFrame.size.height -= tempViewFrame.origin.y;
    tempViewFrame.origin.x = tempViewFrame.size.width;
    for (UIView* view in views) {
        view.frame = tempViewFrame;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setCurrentViewIndex:0 animated:NO];
}

- (void)setCurrentViewIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_currentViewIndex == index || index >= self.views.count) {
        return;
    }
    
    if (!animated) {
        _currentViewIndex = index;
        self.segmentedControl.selectedIndex = index;
        CGRect viewFrame = self.view.bounds;
        viewFrame.origin.y = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height;
        viewFrame.size.height -= viewFrame.origin.y;
        UIView* currentView = [self.views objectAtIndex:index];
        currentView.frame = viewFrame;
    }
    else
    {
        UIView* currentView = [self.views objectAtIndex:_currentViewIndex];
        UIView* nextView = [self.views objectAtIndex:index];
        CGRect viewFrame = self.view.bounds;
        viewFrame.origin.y = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height;
        viewFrame.size.height -= viewFrame.origin.y;
        CGRect curentViewHideFrame = viewFrame;
        if (index > _currentViewIndex) {
            CGRect nextViewFrame = viewFrame;
            nextViewFrame.origin.x = viewFrame.size.width;
            nextView.frame = nextViewFrame;
            curentViewHideFrame.origin.x -= viewFrame.size.width;
        }
        else
        {
            CGRect nextViewFrame = viewFrame;
            nextViewFrame.origin.x -= viewFrame.size.width;
            nextView.frame = nextViewFrame;
            curentViewHideFrame.origin.x = viewFrame.size.width;
        }
        _currentViewIndex = index;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        
        currentView.frame = curentViewHideFrame;
        nextView.frame = viewFrame;
        
        [UIView commitAnimations];
        [self.segmentedControl setSelectedIndex:index animated:YES];
        
    }
    [self handleCurrentViewChanged:_currentViewIndex];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	[self setCurrentViewIndex:segmentedControl.selectedIndex animated:YES];
}

- (void)handleCurrentViewChanged:(NSInteger)index
{
    
}

@end
