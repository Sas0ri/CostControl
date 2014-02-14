//
//  BudgetCell.m
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "BudgetCell.h"
#import "HHUtils.h"

@interface BudgetCell()


@end

@implementation BudgetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		if (self = [super initWithCoder:aDecoder]) {
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
		}
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textDidChange:(NSNotification *)sender
{
	UITextField* textField = sender.object;
	if (textField == self.budgetField) {
		[self.delegate budgetDidChange:textField.text cell:self];
	}
}

- (void)setModel:(BudgetDetailModel *)model
{
	_model = model;
	self.number.text = model.planAmount;
	if (self.sum > 0.0f) {
		double percent = model.realAmount.doubleValue/self.sum*100;
		self.percent.text = [NSString stringWithFormat:@"%0.2f%%",percent];
	} else {
		self.percent.text = @"--";
	}
	self.budgetField.text = [HHUtils regularStringFromDic:model.realAmount];
	self.chargeLabel.text = model.chargeName;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
