//
//  HHWorker.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHWorker.h"
#import "HHCompany.h"
#import "HHUtils.h"

@implementation HHWorker


- (id)initWithDictionery:(NSDictionary *)dic
{
    if (self) {
        [self setData:dic];
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    NSNumber* number = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_corp_id"]];
    self.cid = number.integerValue;
    self.uid = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_openid"]];
    //self.wid = [data objectForKey:@"worker_id"];
    self.name = [data objectForKey:@"worker_name"];
    number = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_dept_id"]];
    self.did = number;
	self.wid = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_id"]];
	self.tel = [HHUtils validateString:[data objectForKey:@"worker_tel"]];
	self.isCeo = [data[@"worker_isceo"] isEqualToString:@"Y"];
}

+ (HHWorker*)workerWithData:(NSDictionary *)data
{
    NSNumber* cid = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_corp_id"]];
    NSNumber* wid = [HHUtils numberIdFromJsonId:[data objectForKey:@"worker_id"]];
    if (cid == nil || wid == nil) {
        return nil;
    }
	HHWorker* worker = [[HHWorker alloc] initWithDictionery:data];
    return worker;
}

+ (HHWorker*)workerWithId:(NSNumber *)wid
{
    HHWorker* worker = [[HHWorker alloc] init];
    worker.wid = wid;
    return worker;
}


- (NSString*)deptListString
{
    NSString* list = nil;
    HHCompany *company = [HHCompany getCompanyWithId:self.cid];
    for (NSNumber* deptId in self.parentDepts) {
        HHDept* dept = [company findDept:deptId];
        if (dept.name.length > 0) {
            if (list == nil) {
                list = [NSString stringWithFormat:@"%@", dept.name];
            }
            else
            {
                list = [NSString stringWithFormat:@"%@/%@",list, dept.name];
            }
        }
        
    }
    return list;
}


@end
