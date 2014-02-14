//
//  HHAttachCell.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-23.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHAttachCell.h"

@implementation HHAttachCell

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

    // Configure the view for the selected state
}

- (void)setAttach:(HHAttach *)attach
{
    _attach = attach;
    self.fileIconImageView.image = _attach.fileIcon;
    self.nameLabel.text = _attach.fileName;
}

@end
