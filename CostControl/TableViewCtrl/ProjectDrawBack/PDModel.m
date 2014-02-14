//
//  PDModel.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "PDModel.h"

@implementation PDModel

- (instancetype)initWithDic:(NSDictionary*)modelDic
{
	if (self = [self init]) {
		_pid = @([modelDic[@"id"] longLongValue]);
		_name = modelDic[@"client_name"];
		_contact = modelDic[@"client_telephone"];
		_receipt = modelDic[@"receipt_no"];
		_pos = modelDic[@"poss_no"];
		_bankAccount = modelDic[@"bank_card_no"];
		_receivedAmount = [modelDic[@"received_groupbuy_amount"] stringValue];
		_returnAmount = [modelDic[@"return_amount"] stringValue];
		_confirmed = [modelDic[@"cwhd_amount"] stringValue];
	}
	return self;
}

@end
