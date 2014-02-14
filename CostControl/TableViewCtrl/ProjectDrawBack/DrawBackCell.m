//
//  ConfirmCell.m
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "DrawBackCell.h"
#import "HHUtils.h"

@interface DrawBackCell()
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *backAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomingLabel;
@property (weak, nonatomic) IBOutlet UILabel *drawBackLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;

@end

@implementation DrawBackCell

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
	if (textField == self.confirmField)
		[self.delegate textDidConfirm:textField.text cell:self];
}


- (void)setModel:(PDModel *)model
{
	_model = model;
	self.nameLabel.text = model.name;
	self.contactLabel.text = model.contact;
	self.receiptLabel.text = model.receipt;
	self.posLabel.text = model.pos;
	self.backAccountLabel.text = model.bankAccount;
	self.incomingLabel.text = [HHUtils regularStringFromDic:model.receivedAmount];
	self.drawBackLabel.text = [HHUtils regularStringFromDic:model.returnAmount];
	self.confirmField.text = [HHUtils regularStringFromDic: model.confirmed];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
