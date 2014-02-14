//
//  HHBaseTableViewController.m
//  Huhoo
//
//  Created by Sasori on 13-6-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHBaseTableViewController.h"
#import "HHUtils.h"

@interface HHBaseTableViewController ()
- (void)backAction:(id)sender;
@end

@implementation HHBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
        self.backButton = [HHUtils navLeftButtonWithTitle:presentedViewController.navigationItem.title];
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
	[self.navigationItem hidesBackButton];
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
