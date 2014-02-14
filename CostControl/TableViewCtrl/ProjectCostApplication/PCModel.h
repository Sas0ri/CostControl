//
//  PCModel.h
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCModel : NSObject
- (instancetype)initWithDic:(NSDictionary*)dic;
@property (nonatomic, strong) NSArray* detailList;
@property (nonatomic, strong) NSString* sum;
@property (nonatomic, strong) NSString* percent;
@property (nonatomic, strong) NSString* remark;
@property (nonatomic, assign) double financeAmount;
@property (nonatomic, assign) double financeQuota;
@end

@interface PCDetailModel : NSObject
@property (nonatomic,strong) NSNumber* pid;
@property (nonatomic, strong) NSString* chargeName;
@property (nonatomic, strong) NSString* applyingAmount;
@property (nonatomic, strong) NSString* spAmount;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
