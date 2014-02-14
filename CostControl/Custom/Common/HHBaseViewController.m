//
//  HHBaseViewController.m
//  Huhoo
//
//  Created by Sasori on 13-6-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHBaseViewController.h"
#import "HHUtils.h"

@interface HHBaseViewController ()

@end

@implementation HHBaseViewController

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

    UIViewController* presentedViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if (presentedViewController.navigationItem.title.length > 0) {
        self.backButton = [HHUtils navLeftButtonWithTitle:@"返回"];
    }
    else if([presentedViewController isKindOfClass:[UITabBarController class]])
    {
        presentedViewController = [(UITabBarController*)presentedViewController selectedViewController];
        if ([presentedViewController valueForKey:@"navTitleView"] && [[presentedViewController valueForKey:@"navTitleView"] isKindOfClass:[UILabel class]]) {
            UILabel * titleLabel = [presentedViewController valueForKey:@"navTitleView"];
            self.backButton = [HHUtils navLeftButtonWithTitle:titleLabel.text];
        }
    }
	[self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
