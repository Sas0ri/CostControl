//
//  HHApprovalListCell.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalListCell.h"
#import "UIImageView+WebCache.h"
#import "HHUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation HHApprovalListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.authorAvatarImageView.layer.masksToBounds = YES;
    self.authorAvatarImageView.layer.cornerRadius = self.authorAvatarImageView.bounds.size.width/2;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 1)];
    view.backgroundColor = [HHUtils hexStringToColor:@"#dbdbdb"];
    [self addSubview:view];
    view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(HHApprovalItem *)item
{
    _item = item;
    [self.authorAvatarImageView setImageWithURL:item.avatarUrl placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    self.titleLabel.text = item.sqName;

    if (self.authorLabel) {
        self.authorLabel.text = [NSString stringWithFormat:@"[%@] %@", [HHUtils getLeafDepartmentString:item.deptName], item.workerName];
    }
    if (self.statusLabel) {
        if (item.status.integerValue == 2) {
            self.statusLabel.text = @"不同意";
            self.statusLabel.textColor = [UIColor redColor];
        }
        else if (item.status.integerValue == 3)
        {
            self.statusLabel.text = @"同意";
            self.statusLabel.textColor = [HHUtils hexStringToColor:@"#14a5a2"];
        }
        else if (item.status.integerValue == 1)
        {
            self.statusLabel.text = @"审批中";
            self.statusLabel.textColor = [HHUtils hexStringToColor:@"#07a8fc"];
        } else if (item.status.integerValue == 0) {
			self.statusLabel.text = @"回退";
            self.statusLabel.textColor = [HHUtils hexStringToColor:@"#07a8fc"];
		}
    }
	self.tagLabel.hidden = NO;
	if (item.isReminded) {
		self.tagLabel.text = @"[催办]";
	} else if (item.isBack){
		self.tagLabel.text = @"[回退]";
	} else if (item.isHurry) {
		self.tagLabel.text = @"[紧急]";
	} else {
		self.tagLabel.hidden = YES;
	}
	self.timeLabel.text = [HHUtils standardDateDayString:item.updateTime];
    [self updateSubViewsFrame];
}


- (void)updateSubViewsFrame
{
    CGRect frame = self.timeLabel.frame;
    
    CGFloat textWidth = [self.timeLabel.text sizeWithFont:self.timeLabel.font constrainedToSize:CGSizeMake(240, self.timeLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping].width+2;
    frame.origin.x = frame.origin.x + frame.size.width - textWidth;
    frame.size.width = textWidth;
    self.timeLabel.frame = frame;
    
	frame = self.titleLabel.frame;
	textWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(240, self.titleLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping].width+2;
    frame.size.width = textWidth;
    self.titleLabel.frame = frame;
	
	CGRect r = self.tagLabel.frame;
	r.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width+2;
	self.tagLabel.frame = r;

}

@end
