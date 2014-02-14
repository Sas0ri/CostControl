//
//  HHDept.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHDept.h"
#import "HHCompany.h"
#import "HHUtils.h"

@implementation HHDept


-(NSMutableArray*)childDepts
{
    if (_childDepts == nil) {
        _childDepts = [[NSMutableArray alloc] init];
    }
    return _childDepts;
}

- (NSMutableArray*)workers
{
    if (_workers == nil) {
        _workers = [[NSMutableArray alloc] init];
    }
    return _workers;
}

-(id)initWithDictionery:(NSDictionary *)dic
{
    if (self) {
        [self setData:dic];
        
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    self.cid = [data[@"corp_id"] integerValue];
    self.did = @([[data objectForKey:@"dept_id"] longLongValue]);
    self.name =  [HHUtils trimDepartment:[data objectForKey:@"dept_name"]] ;
	self.parentDept = @([data[@"dept_fid"] longLongValue]);
}

+ (HHDept*)deptWithData:(NSDictionary *)data
{
    if (data == nil || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSNumber* cid = @([[data objectForKey:@"corp_id"] longLongValue]);
    NSNumber* did = @([[data objectForKey:@"dept_id"] longLongValue]);
    if (cid == nil || did == nil) {
        return nil;
    }
	//    HHCompany* company = [HHCompany findCompanyWithId:cid.integerValue];
	//    if (company == nil) {
	//        return nil;
	//    }
	//    HHDept* dept = [company getDept:did];
	HHDept* dept = [[HHDept alloc] initWithDictionery:data];
	//    [dept setData:data];
    return dept;
}

+ (HHDept*)deptWithId:(NSNumber *)did
{
    HHDept* dept = [[HHDept alloc] init];
    dept.did = did;
    return dept;
}

- (void)addWorker:(HHWorker*)worker
{
	if ([self.workers indexOfObject:worker.wid] == NSNotFound)
		[self.workers addObject:worker.wid];
//	HHCompany* company = self.parentCompany;
//	for (NSNumber* parentDeptId in self.parentDepts) {
//		HHDept* parentDept = [company getDept:parentDeptId];
//		if ([parentDept.workers indexOfObject:worker.wid] == NSNotFound) {
//			[parentDept.workers addObject:worker.wid];
//		}
//	}
//	NSMutableArray* tempWorkerDeptIds = [NSMutableArray arrayWithArray:self.parentDepts];
//	[tempWorkerDeptIds addObject:self.did];
//	worker.parentDepts = tempWorkerDeptIds;
	
}

@end
