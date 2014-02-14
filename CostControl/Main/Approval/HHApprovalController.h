//
//  HHApprovalController.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTabBarController.h"
#import "HHApprovalItemModel.h"
#import "EGOViewCommon.h"
#import "SINavigationMenuView.h"
#import "PPRevealSideViewController.h"

@interface HHApprovalController : HHTabBarController <UITableViewDataSource, UITableViewDelegate, HHApprovalItemModelDelegate, EGORefreshTableDelegate, UIScrollViewDelegate, SINavigationMenuDelegate, PPRevealSideViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *waitTableView;
@property (weak, nonatomic) IBOutlet UITableView *overTableView;
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;
@property (weak, nonatomic) IBOutlet UITableView *ccTableView;

@property (nonatomic, strong) NSDictionary* tableViews;

@end
