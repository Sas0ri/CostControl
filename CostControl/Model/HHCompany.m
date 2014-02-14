//
//  HHCompany.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013Âπ?Huhoo. All rights reserved.
//

#import "HHCompany.h"
#import "HHAccount.h"
#import "AFHTTPRequestOperation.h"
#import "HHWorker.h"
#import "HHOpenClient.h"
#import "NSObject+SBJson.h"
#import "CDUserInfo.h"
#import "HHDB.h"

static NSMutableArray* sharedCompanysCache = nil;

@implementation HHCompany

- (NSMutableDictionary*)workersCache
{
    if (_workersCache == nil) {
        _workersCache = [[NSMutableDictionary alloc] init];
    }
    return _workersCache;
}

- (NSMutableDictionary*)deptsCache
{
    if (_deptsCache == nil) {
        _deptsCache = [[NSMutableDictionary alloc] init];
    }
    return _deptsCache;
}

- (HHWorker*)getWorker:(NSNumber *)wid
{
    HHWorker* worker = [self findWorker:wid];
    if (worker == nil) {
        worker = [HHWorker workerWithId:wid];
        [self.workersCache setObject:worker forKey:wid];
    }
    return worker;
}

- (HHWorker*)findWorker:(NSNumber *)wid
{
    for (HHWorker* worker in self.workersCache.allValues) {
        if ([worker.wid isEqualToNumber:wid]) {
            return worker;
        }
    }
    return nil;
}

- (HHWorker *)findWorkerWithName:(NSString *)name dept:(NSString *)dept
{
	for (HHWorker* worker in self.workersCache.allValues) {
		HHDept* dep = [self getDept:worker.did];
		if ([worker.name isEqualToString:name] && [dept isEqualToString:dep.name]) {
			return worker;
		}
	}
	return nil;
}

- (HHWorker*)workerWithUid:(NSNumber *)uid
{
    if (![HHWorker isUidValid:uid.integerValue]) {
        return nil;
    }
    for (HHWorker* worker in self.workersCache.allValues) {
        if (worker.uid.integerValue == uid.integerValue) {
            return worker;
        }
    }
    return nil;
}

+ (HHWorker*)firstWorkerWithUid:(int64_t)uid
{
	HHWorker* result = nil;
    for (HHCompany* company in sharedCompanysCache) {
        HHWorker* worker = [company workerWithUid:@(uid)];
        if (worker) {
            result = worker;
			if (company.cid == [HHAccount sharedAccount].currentCid) {
				break;
			}
        }
    }
    return result;
}

- (HHDept*)getDept:(NSNumber *)did
{
    HHDept* dept = [self findDept:did];
    if (dept == nil) {
        dept = [HHDept deptWithId:did];
        [self.deptsCache setObject:dept forKey:did];
    }
    return dept;
}

- (HHDept*)findDept:(NSNumber *)did
{
	if (did == nil) {
		return nil;
	}
    for (HHDept* dept in self.deptsCache.allValues) {
        if ([dept.did isEqualToNumber:did]) {
            return dept;
        }
    }
	return nil;
}

//- (NSArray*)rootDepts
//{
//    if (self.deptsCache.count == 0) {
//        return nil;
//    }
//    NSMutableArray* depts = [[NSMutableArray alloc] init];
//    for (HHDept* dept in self.deptsCache.allValues) {
//        if (dept.parentDepts == nil || dept.parentDepts.count == 0) {
//            [depts addObject:dept.did];
//        }
//    }
//    return depts;
//}

- (void)getStructSuccess:(void (^)())success failure:(void (^)(int))failure
{
    [[HHOpenClient sharedClient] getCompanyStruct:self.cid success:^(NSString* responseString){
        if ([self initStructWithString:responseString]) {
            success();
			[self structUpdated];
        }
        else
        {
            failure(kRequestConnectionErrorCode);
        }
    }failure:^(int code){
        failure(code);
    }];
}

- (void)structUpdated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kStructHasUpdatedNotification object:self userInfo:[NSDictionary dictionaryWithObject:@(self.cid) forKey:@"cid"]];
}

- (BOOL)initStructWithString:(NSString *)string
{
    self.structString = string;
    NSDictionary *dic = [string JSONValue];
    NSNumber* code = [dic valueForKeyPath:@"code"];
    if (code != nil && code.integerValue == 0) {
        [self.workersCache removeAllObjects];
        [self.deptsCache removeAllObjects];
        NSDictionary* extItems = [dic valueForKeyPath:@"ext"];
        if (extItems != nil && [extItems objectForKey:@"ref"] != nil && [[extItems objectForKey:@"ref"] isKindOfClass:[NSString class]]) {
			NSString* refStr = extItems[@"ref"];
			NSArray* refs = [refStr componentsSeparatedByString:@"/"];
            if ([refs containsObject:@"d"]) {
                NSArray* allDepts = [extItems objectForKey:@"d"];
//                NSArray* allDepts = [deptItems allValues];
                for (NSDictionary* deptInfo in allDepts) {
                    HHDept* dept = [HHDept deptWithData:deptInfo];
					dept.parentCompany = self;
					[self.deptsCache setObject:dept forKey:dept.did];
                }
            }
            if ([refs containsObject:@"w"]) {
                NSArray* allWorkers = [extItems objectForKey:@"w"];
                for (NSDictionary* workerInfo in allWorkers) {
                    HHWorker* worker = [HHWorker workerWithData:workerInfo];
                    if (worker) {
						[self.workersCache setObject:worker forKey:worker.wid];
                        HHDept* parentDept = [self findDept:worker.did];
                        if (parentDept) {
                            [parentDept addWorker:worker];
                        }
                    }
                }
            }
            
            if ([refs containsObject:@"u"]) {
                NSArray* allUs = extItems[@"u"];
                for (NSDictionary* uInfo in allUs) {
                    if (uInfo != nil) {
                        int64_t uid = [[uInfo objectForKey:@"uid"] longLongValue];
                        for (HHWorker* worker in self.workersCache.allValues) {
                            if (worker.uid.integerValue == uid) {
                                worker.avatarUrl = [uInfo objectForKey:@"headpic_url"];
                                if (uid == [HHAccount sharedAccount].uid.longLongValue) {
                                    [HHAccount sharedAccount].name = worker.name;
									[HHAccount sharedAccount].isCeo = worker.isCeo;
                                }
                            }
                        }
                        
                    }
                }
                
            }
            return YES;
        }
    }
    return NO;
}

+ (HHCompany *)getCompanyWithId:(int64_t)cid
{
    if (sharedCompanysCache == nil) {
        sharedCompanysCache = [[NSMutableArray alloc] init];
    }
    for (HHCompany* company in sharedCompanysCache) {
        if (company.cid == cid) {
            return company;
        }
    }
    HHCompany* company = [[HHCompany alloc] init];
    company.cid = cid;
    [sharedCompanysCache addObject:company];
    return company;
}

+ (HHCompany *)findCompanyWithId:(int64_t)cid
{
	if (sharedCompanysCache == nil) {
        sharedCompanysCache = [[NSMutableArray alloc] init];
    }
    for (HHCompany* company in sharedCompanysCache) {
        if (company.cid == cid) {
            return company;
        }
    }
	return nil;
}

+ (HHCompany*)companyWithId:(NSNumber *)cid
{
    return [HHCompany findCompanyWithId:cid.integerValue];
}

+ (void)removeComponyWithId:(int64_t)cid
{
	if (sharedCompanysCache == nil) {
        sharedCompanysCache = [[NSMutableArray alloc] init];
    }
	HHCompany* c = [HHCompany findCompanyWithId:cid];
	if(c)
	{
		[sharedCompanysCache removeObject:c];
//		[[HHDB sharedDB] removeCommanyById:cid];
	}
}

+ (NSArray*)companys
{
    return sharedCompanysCache;
}

+ (void)reset
{
	sharedCompanysCache = nil;
}

+ (void)clearDB
{
	if (sharedCompanysCache) {
		for (HHCompany* c in sharedCompanysCache) {
//			[[HHDB sharedDB] removeCommanyById:c.cid];
		}
		[self reset];
    }
}

+ (void)loadCompanys
{
	if (sharedCompanysCache != nil && sharedCompanysCache.count > 0) {
		return;
	}
//	NSArray* arr = [[HHDB sharedDB] loadCompanys];
	if (sharedCompanysCache == nil) {
        sharedCompanysCache = [[NSMutableArray alloc] init];
	}
//	[sharedCompanysCache addObjectsFromArray:arr];
}

@end
