//
//  HHCompany.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013å¹?Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHWorker.h"
#import "HHDept.h"

#define kStructHasUpdatedNotification @"kStructHasUpdatedNotification"

@interface HHCompany : NSObject

@property (nonatomic) int64_t cid;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *shortname;
@property (nonatomic, strong) NSMutableDictionary* workersCache;
@property (nonatomic, strong) NSMutableDictionary* deptsCache;
@property (nonatomic, strong) NSString *structString;
@property (nonatomic) int64_t structStamp;


- (HHWorker*)getWorker:(NSNumber*)wid;
- (HHWorker*)findWorker:(NSNumber*)wid;
- (HHWorker*)workerWithUid:(NSNumber *)uid;
+ (HHWorker*)firstWorkerWithUid:(int64_t)uid;
- (HHWorker*)findWorkerWithName:(NSString*)name dept:(NSString*)dept;

- (HHDept*)getDept:(NSNumber*)did;
- (HHDept*)findDept:(NSNumber*)did;
//- (NSArray*)rootDepts;

- (void)getStructSuccess:(void (^)())success failure:(void (^)(int))failure;
- (BOOL)initStructWithString:(NSString*)string;

+ (HHCompany*)getCompanyWithId:(int64_t)cid;
+ (HHCompany*)findCompanyWithId:(int64_t)cid;
+ (HHCompany*)companyWithId:(NSNumber*)cid;
+ (void)removeComponyWithId:(int64_t)cid;
+ (NSArray*)companys;
+ (void)reset;
+ (void)clearDB;
+ (void)loadCompanys;

@end
