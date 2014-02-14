//
//  HHApprovalItem.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HHApprovalItem : NSObject

@property (nonatomic, strong)NSString* type;
@property (nonatomic, strong)NSNumber* sqId;
@property (nonatomic, strong)NSNumber* chkId;
@property (nonatomic, strong)NSNumber* ccId;
@property (nonatomic, strong)NSDictionary* data;
@property (nonatomic, strong)NSDate* primaryDate;
@property (nonatomic, strong) NSDate* updateTime;
@property (nonatomic, strong)NSString* sqName;
@property (nonatomic, strong)NSNumber* status;
@property (nonatomic, strong)NSNumber* workerId;
@property (nonatomic, strong)NSURL* avatarUrl;
@property (nonatomic, strong)NSString* workerName;
@property (nonatomic, strong)NSNumber* deptId;
@property (nonatomic, strong)NSString* deptName;
@property (nonatomic, strong)NSNumber* copId;
@property (nonatomic, strong) NSNumber * fdId;
@property (nonatomic, strong) NSNumber* fcId;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, assign) BOOL isHurry;
@property (nonatomic, assign) BOOL isBack;
@property (nonatomic, assign) BOOL isReminded;

- (id)initWithData:(NSDictionary*)data;
- (BOOL)isEqualToApprovalItem:(HHApprovalItem*)anotherApprovalItem;

@end
