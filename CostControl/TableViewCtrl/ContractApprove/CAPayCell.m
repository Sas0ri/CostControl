//
//  CaPayCell.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CAPayCell.h"
#import "HHUtils.h"

@implementation CAPayCell

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

- (void)setModel:(NSDictionary *)model
{
	_model = model;
	self.countLabel.text = [NSString stringWithFormat:@"第%@次", [model[@"nth_payment"] stringValue]];
	self.dateLabel.text = model[@"payment_time"];
	self.moneyLabel.text = [HHUtils regularStringFromDic:model[@"payment_amount"]];
}

@end
