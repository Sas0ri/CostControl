//
//  HHWorker.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHUser.h"

@interface HHWorker : HHUser

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSNumber *wid;
@property (nonatomic, strong) NSNumber *did;
@property (nonatomic, strong) NSArray* parentDepts;
@property (nonatomic, strong) NSString* tel;

-(id)initWithDictionery:(NSDictionary*)dic;
-(void)setData:(NSDictionary*)data;

+ (HHWorker*)workerWithId:(NSNumber*)wid;
+ (HHWorker*)workerWithData:(NSDictionary*)data;
- (NSString*)deptListString;

@end
