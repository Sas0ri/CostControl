//
//  HHApprovalDetailController.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHApprovalItem.h"
#import "CustomSegmentedControl.h"
#import "HHBaseViewController.h"

@interface HHApprovalDetailController : HHBaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,CustomSegmentedControlDelegate>
@property (nonatomic, strong) HHApprovalItem* item;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITableView *attachsTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) CustomSegmentedControl *viewsSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *titleBackgroundImageView;

@property (nonatomic, strong) NSDictionary* detailData;
@property (nonatomic, strong) NSArray* attachs;
@property (nonatomic, strong) NSArray* comments;

- (IBAction)handle:(id)sender;
- (IBAction)handleCurrentViewChanged:(UISegmentedControl *)sender;

@end
