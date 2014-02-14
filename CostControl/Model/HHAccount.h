//
//  HHAccount.h
//  CostControl
//
//  Created by Sasori on 14-1-15.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHUser.h"

#define kOauthTokenKey  @"oauth_token"
#define kOauthTokenSecretKey    @"oauth_token_secret"
#define kUidKey @"uid"
#define kUsernameKey    @"username"
#define kPasswordKey    @"password"

#define kHuhooOAuthCustomerKey   @"apple.huhoo.cn"
#define kHuhooOAuthCustomerSecret @"apple.huhoo.cn_"
#define kHuhooOAuthMode  @"client_auth"
#define kHuhooOAuthVersion   @"1.0"
#define kHuhooOAuthSignatureMethod   @"HMAC-SHA1"

#define HHCurrentCompanyChangedNotification @"HHCurrentCompanyChangedNotification"
#define HHCurrentCompanyKey @"HHCurrentCompanyKey"

@interface HHAccount : HHUser

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic) int64_t currentCid;
@property (nonatomic, assign) BOOL hasSignedIn;
@property (nonatomic, strong) NSString* birthDay;

+ (instancetype)sharedAccount;
- (void)initWhenSignInSuccess:(NSNumber*)uid;
- (void)signInSuccess:(void (^)(int8_t code))success failure:(void (^)(int8_t code))failure;
- (void)signOut;
- (BOOL)hasSignedIn;
@end
