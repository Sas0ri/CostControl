//
//  PCModel.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "PCModel.h"

@implementation PCModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		NSMutableArray* arr = [NSMutableArray array];
		NSArray* dics = dic[@"detail"];
		double sum = 0;
		for (NSDictionary* info in dics) {
			PCDetailModel* dm = [[PCDetailModel alloc] initWithDic:info];
			[arr addObject:dm];
			if (dm.spAmount.doubleValue > 0.0f) {
				sum += dm.spAmount.doubleValue;
			} else {
				sum += dm.applyingAmount.doubleValue;
			}
		}
		_detailList = arr;
		
		_financeAmount = [dic[@"finance_amount"] doubleValue];
		_financeQuota = [dic[@"finance_quota"] doubleValue];
		_remark = dic[@"remark"];
		_sum = [NSString stringWithFormat:@"%f", sum];
		if (_financeQuota > 0.0) {
			_percent = [NSString stringWithFormat:@"%0.2f%%",(_sum.doubleValue + _financeAmount)/_financeQuota*100];
		} else {
			_percent = @"--";
		}
	}
	return self;
}

@end

@implementation PCDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		_pid = @([dic[@"id"] longLongValue]);
		_chargeName = dic[@"charge_name"];
		_applyingAmount = [dic[@"applying_amount"] stringValue];
		_spAmount = [dic[@"sp_amount"] stringValue];
	}
	return self;
}

@end
