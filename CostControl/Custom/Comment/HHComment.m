//
//  HHComment.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-23.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHComment.h"
#import "HHCompany.h"
#import "HHAccount.h"
#import "HHUtils.h"

@implementation HHComment

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		HHCompany* company = [HHCompany getCompanyWithId:[HHAccount sharedAccount].currentCid];
		NSNumber* wid = @([dic[@"fm_wid"] longLongValue]);
		HHWorker* worker = [company getWorker:wid];
		HHDept* dept = [company getDept:worker.did];
		self.dept = dept.name;
		self.workerName = worker.name;
		self.avatarUrl = [NSURL URLWithString:[HHUtils avatarUrlString:worker.avatarUrl]];
		self.content = dic[@"fm_msg"];
		self.time = dic[@"fm_time"];
		if ([dic[@"tit"] isKindOfClass:[NSString class]]) {
			self.result = [self titToResult:dic[@"tit"]];
		}
	}
	return self;
}

- (NSString*)titToResult:(NSString*)tit
{
	if ([tit isEqualToString:@"agree2next"] || [tit isEqualToString:@"agree2over"]) {
		return @"同意";
	}
	if ([tit isEqualToString:@"back2next"]) {
		return @"回退";
	}
	if ([tit isEqualToString:@"reply2next"]) {
		return @"回复";
	}
	if ([tit isEqualToString:@"disagree2over"]) {
		return @"不同意";
	}
	return @"";
}

@end
