//
//  HHUser.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserQRCodeHost     @"http://www.huhoo.com/download/?jid="
#define KUserQRCodeHost2    @"http://user.huhoo.com/"

@interface HHUser : NSObject

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSString* age;
@property (nonatomic, strong) NSString* tel;
@property (nonatomic, assign) BOOL isCeo;
+ (BOOL)isUidValid:(NSInteger)uid;


@end
