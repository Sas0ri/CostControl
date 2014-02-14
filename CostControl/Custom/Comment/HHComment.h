//
//  HHComment.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-23.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHComment : NSObject

@property (nonatomic, strong) NSString* dept;
@property (nonatomic, strong) NSString* workerName;
@property (nonatomic, strong) NSURL* avatarUrl;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* result;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
