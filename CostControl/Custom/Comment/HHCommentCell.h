//
//  HHCommentCell.h
//  Huhoo
//
//  Created by Jason Chong on 13-1-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHComment.h"

@interface HHCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) HHComment* comment;

+ (CGFloat)cellHeight:(HHComment*)comment;
+ (CGFloat)contentHeight:(NSString*)text;

@end

@interface HHSepLine : UIView

@end