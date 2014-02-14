//
//  PDModel.h
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDModel : NSObject
@property (nonatomic, strong) NSNumber* pid;
@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *receipt;
@property (strong, nonatomic) NSString *pos;
@property (strong, nonatomic) NSString *bankAccount;
@property (strong, nonatomic) NSString *receivedAmount;
@property (strong, nonatomic) NSString *returnAmount;
@property (strong, nonatomic) NSString *confirmed;
- (instancetype)initWithDic:(NSDictionary*)modelDic;
@end
