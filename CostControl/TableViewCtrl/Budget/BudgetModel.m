//
//  BudgetModel.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "BudgetModel.h"

@implementation BudgetModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		NSMutableArray* list = [NSMutableArray array];
		NSArray* arr = dic[@"in"];
		double inSum = 0;
		for (NSDictionary* dic in arr) {
			BudgetDetailModel* model = [[BudgetDetailModel alloc] initWithDic:dic];
			inSum += model.realAmount.doubleValue;
			[list addObject:model];
		}
		_inSum = [NSString stringWithFormat:@"%f", inSum];
		
		_inList = list;
		arr = dic[@"out"];

		double outSum = 0;
		list = [NSMutableArray array];
		for (NSDictionary* dic in arr) {
			BudgetOutModel* model = [[BudgetOutModel alloc] initWithDic:dic];
			outSum += model.outSum.doubleValue;
			[list addObject:model];
		}
		_outSum = [NSString stringWithFormat:@"%f", outSum];
		_outList = list;
	}
	return self;
}

@end

@implementation BudgetDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		_bid = dic[@"sye_id"];
		_chargeName = dic[@"sy_finance_name"];
		_planAmount = [dic[@"sy_plan_quota"] stringValue];
		if ([dic[@"sy_real_quota"] doubleValue] > 0) {
			_realAmount = [dic[@"sy_real_quota"] stringValue];
		} else {
			_realAmount = _planAmount;
		}
	}
	return self;
}

@end

@implementation BudgetOutModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		_outDetail = dic[@"finance_name"];
		_bid = dic[@"sye_id"];

		double outSum = 0;
		NSMutableArray* list = [NSMutableArray array];
		NSArray* arr = dic[@"children"];
		for (NSDictionary* dic in arr) {
			BudgetDetailModel* model = [[BudgetDetailModel alloc] initWithDic:dic];
			outSum += model.realAmount.doubleValue;
			[list addObject:model];
		}
		_outSum = [NSString stringWithFormat:@"%f", outSum];
		_detailList = list;
	}
	return self;
}

@end