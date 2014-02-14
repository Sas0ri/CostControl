//
//  PICModel.h
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PICModel : NSObject
@property (nonatomic, strong) NSString* contact;
@property (nonatomic, strong) NSNumber* pid;
@property (strong, nonatomic) NSString *receipt;
@property (strong, nonatomic) NSString *pos;
@property (strong, nonatomic) NSString *card;
@property (strong, nonatomic) NSString *cash;
@property (strong, nonatomic) NSString *confirm;
@property (strong, nonatomic) NSString *confirmed;
- (instancetype)initWithDic:(NSDictionary*)modelDic;

@end