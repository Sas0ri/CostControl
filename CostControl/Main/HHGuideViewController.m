//
//  HHGuideViewController.m
//  Huhoo
//
//  Created by Jason Chong on 13-5-21.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHGuideViewController.h"
#import "UIColor+expanded.h"
#import "FlatUIKit.h"

#define kGuidePageCount 4

@interface HHGuideViewController ()
- (void)enterAction:(id)sender;
@end

@implementation HHGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.backgroundColor = [UIColor whiteColor];
    self.animating = NO;
    
    CGRect frame = [[UIScreen mainScreen] bounds];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    

	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.0, self.view.bounds.size.height - 44, 280, 20)];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    self.pageControl.numberOfPages = kGuidePageCount;
    self.pageControl.currentPage = 0;
	[self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"6cab36"]];
	[self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    
    NSMutableArray* imageNameArray = [[NSMutableArray alloc] initWithCapacity:kGuidePageCount];
    for (int index = 0; index < kGuidePageCount; index++) {
        if (frame.size.height > 480.0f) {
            [imageNameArray addObject:[NSString stringWithFormat:@"guide_%d-568h", index+1]];
        }
        else
        {
            [imageNameArray addObject:[NSString stringWithFormat:@"guide_%d", index+1]];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageNameArray.count, frame.size.height);
    
    NSString *imgName = nil;
    UIImageView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIImageView alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width * i), 0.f, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
		view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [view setImage:[UIImage imageNamed:imgName]];
        [self.scrollView addSubview:view];
		
		if (i == kGuidePageCount - 1) {
			UIButton* enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
			enterButton.frame = CGRectMake(80, frame.size.height - 135, 160, 41);
			[enterButton addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
			enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
			[enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"79bf3d"] cornerRadius:0] forState:UIControlStateNormal];
			[enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"66b12f"] cornerRadius:0] forState:UIControlStateHighlighted];
			[enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
			[view addSubview:enterButton];
			view.userInteractionEnabled = YES;
		}
    }
}

- (void)enterAction:(id)sender
{
	[self hideGuide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	if (!HHIOS7) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (!HHIOS7) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	}
	[super viewWillDisappear:animated];
}

- (void)pageChanged:(UIPageControl *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGRect frame = self.scrollView.frame;
    frame.origin = CGPointMake(pageWidth*sender.currentPage, 0);
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (self.pageControl) {
            int page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
            self.pageControl.currentPage = page;
        }
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + 50.0f) {
            [self hideGuide];
        }
    }
}


- (void)hideGuide
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewControllerHidden:)]) {
        [self.delegate guideViewControllerHidden:self];
    }
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end

