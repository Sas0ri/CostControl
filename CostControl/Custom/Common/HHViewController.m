//
//  HHViewController.m
//  Huhoo
//
//  Created by Jason Chong on 13-1-12.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHViewController.h"
//#import "HHHomeController.h"
#import "HHUtils.h"


@interface HHViewController ()

@end

@implementation HHViewController


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
	// Do any additional setup after loading the view.
    UIButton *button = nil;
    
    NSArray* controllers = self.navigationController.viewControllers;
    UIViewController* presentController = [controllers objectAtIndex:controllers.count-2];
    button = [HHUtils navLeftButtonWithTitle:presentController.title];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem hidesBackButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
