//
//  HHApprovalListCell.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHApprovalItem.h"

@interface HHApprovalListCell : UITableViewCell

@property (nonatomic, strong) HHApprovalItem* item;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel* tagLabel;
@end
