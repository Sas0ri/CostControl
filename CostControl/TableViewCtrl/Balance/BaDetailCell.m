//
//  BaDetailCell.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "BaDetailCell.h"
#import "HHUtils.h"

@implementation BaDetailCell

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
	self.cityCompanyLabel.text = model[@"citycorp_name"];
	self.projectNameLabel.text = model[@"project_name"];
	NSString* str = [NSString stringWithFormat:@"%@-%@", model[@"finance_upname"], model[@"finance_name"]];
	self.costTypeLabel.text = str;
	self.paymentLabel.text = [HHUtils regularStringFromDic:model[@"agent_commission"]];
	self.companyLabel.text = model[@"agent_name"];
}

@end
