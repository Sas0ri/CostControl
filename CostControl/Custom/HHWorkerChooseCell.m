//
//  HHWorkerChooseCell.m
//  Huhoo
//
//  Created by Sasori on 13-4-11.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHWorkerChooseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "HHUtils.h"

@implementation HHWorkerChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[self showSelectedImage:selected];

    // Configure the view for the selected state
}

- (void)showSelectedImage:(BOOL)selected
{
    if (selected) {
        self.selectedImageView.hidden = NO;
    }
    else
    {
        self.selectedImageView.hidden = YES;
    }
}

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    if (avatarUrl == nil || ![avatarUrl isKindOfClass:[NSString class]] || avatarUrl.length == 0) {
        [self.avatarImageView setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    else
    {
        if ([avatarUrl rangeOfString:@"http://"].location == 0 || [avatarUrl rangeOfString:@"https://"].location == 0) {
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        }
        else {
//            [self.avatarImageView setImage:[UIImage imageNamed:avatarUrl]];
			[self.avatarImageView setImageWithURL:[NSURL URLWithString:[HHUtils avatarUrlString:avatarUrl]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

-(void)setDept:(NSString *)dept
{
	_dept = dept;
	self.deptLabel.text = dept;
}

@end
