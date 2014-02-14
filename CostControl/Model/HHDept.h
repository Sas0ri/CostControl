//
//  HHDept.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHWorker.h"

@class HHCompany;
@interface HHDept : NSObject

@property (nonatomic) NSInteger cid;
@property (nonatomic, strong) NSNumber* did;
@property (nonatomic, strong) NSNumber* parentDept;
@property (nonatomic, strong) NSMutableArray *workers;
@property (nonatomic, strong) NSMutableArray *childDepts;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, weak) HHCompany* parentCompany;

-(id)initWithDictionery:(NSDictionary *)dic;
-(void)setData:(NSDictionary*)data;
+ (HHDept*)deptWithData:(NSDictionary*)data;
+ (HHDept*)deptWithId:(NSNumber*)did;
- (void)addWorker:(HHWorker*)worker;

@end
