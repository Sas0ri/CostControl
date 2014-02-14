//
//  HHUser.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHUser.h"
#import "HHUtils.h"


@implementation HHUser

+ (BOOL)isUidValid:(NSInteger)uid
{
    if (uid <= 0) {
        return NO;
    }
    return YES;
}


@end
