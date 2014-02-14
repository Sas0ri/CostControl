//
//  CDAppOauth.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "CDAppOauth.h"


@implementation CDAppOauth

@dynamic customerKey;
@dynamic uid;
@dynamic token;
@dynamic tokenSecret;

- (void)copyWithHHAppOauth:(HHAppOauth *)oauth
{
    self.uid = [NSNumber numberWithLong:oauth.uid.longValue];
    self.token = [oauth.token copy];
    self.tokenSecret = [oauth.tokenSecret copy];
    self.customerKey = [oauth.customerKey copy];
}

- (HHAppOauth*)HHAppOauth
{
    HHAppOauth* oauth = [[HHAppOauth alloc] init];
    oauth.uid = [NSNumber numberWithLong:self.uid.longValue];
    oauth.token = [self.token copy];
    oauth.tokenSecret = [self.tokenSecret copy];
    oauth.customerKey = [self.customerKey copy];
    oauth.appOauthCoreDataId = self.objectID;
    return oauth;
}

@end
