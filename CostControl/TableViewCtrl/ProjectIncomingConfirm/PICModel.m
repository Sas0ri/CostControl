//
//  PICModel.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "PICModel.h"

@implementation PICModel

- (instancetype)initWithDic:(NSDictionary*)modelDic
{
	if (self = [self init]) {
		_contact = modelDic[@"client_name"];
		_pid = @([modelDic[@"id"] longLongValue]);
		_receipt = modelDic[@"receipt_no"];
		_pos = modelDic[@"poss_no"];
		_card = [modelDic[@"card_charge_amount"] stringValue];
		_cash = [modelDic[@"cash_amount"] stringValue];
		double amount = [modelDic[@"confirmed_amount"] doubleValue];
		amount = amount > 0 ? amount : self.card.doubleValue + self.cash.doubleValue;
		_confirm = [NSString stringWithFormat:@"%f", amount];
		_confirmed = [modelDic[@"cwhd_amount"] stringValue];
	}
	return self;
}

@end
