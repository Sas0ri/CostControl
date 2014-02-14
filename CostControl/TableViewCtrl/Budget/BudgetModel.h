//
//  BudgetModel.h
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetModel : NSObject
- (instancetype)initWithDic:(NSDictionary*)dic;
@property (nonatomic, strong) NSArray* inList;
@property (nonatomic, strong) NSArray* outList;
@property (nonatomic, strong) NSString* inSum;
@property (nonatomic, strong) NSString* outSum;
@end

@interface BudgetDetailModel : NSObject
- (instancetype)initWithDic:(NSDictionary*)dic;
@property (nonatomic, strong) NSNumber* bid;
@property (nonatomic, strong) NSString* chargeName;
@property (nonatomic, strong) NSString* planAmount;
@property (nonatomic, strong) NSString* realAmount;
@property (nonatomic, strong) NSString* percent;
@property (nonatomic, assign) double sum;
@end

@interface BudgetOutModel : NSObject
- (instancetype)initWithDic:(NSDictionary*)dic;
@property (nonatomic, strong) NSNumber* bid;
@property (nonatomic, strong) NSString* outDetail;
@property (nonatomic, strong) NSArray* detailList;
@property (nonatomic, strong) NSString* outSum;
@end
