//
//  ConfirmCell.m
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ConfirmCell.h"
#import "HHUtils.h"

@interface ConfirmCell()
@property (weak, nonatomic) IBOutlet UILabel* contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
- (void)textDidChange:(NSNotification*)sender;
@end

@implementation ConfirmCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
	}
	return self;
}

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

- (void)textDidChange:(NSNotification *)sender
{
	UITextField* textField = sender.object;
	if (textField == self.confirmField) {
		[self.delegate textDidConfirm:textField.text cell:self];
	}
}

- (void)setModel:(PICModel *)model
{
	_model = model;
	self.contactLabel.text = model.contact;
	self.receiptLabel.text = model.receipt;
	self.posLabel.text = model.pos;
	self.cardLabel.text = [HHUtils regularStringFromDic:model.card];
	self.cashLabel.text = [HHUtils regularStringFromDic:model.cash];
	self.confirmLabel.text = [HHUtils regularStringFromDic:model.confirm];
	self.confirmField.text = [HHUtils regularStringFromDic:model.confirmed];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
