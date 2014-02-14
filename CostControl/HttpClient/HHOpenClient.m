//
//  HHOpenClient.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013Âπ?Huhoo. All rights reserved.
//

#import "HHOpenClient.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "AFNetworking.h"
#import "HHCompany.h"
#import "HHUtils.h"
//#import "UIImage+fixOrientation.h"
#import "SDImageCache.h"
#import "HHAccount.h"

#ifdef HHDEBUG
	#if HHDEBUG_ON_243
		static NSString* const kHHOpenBaseURLString = @"http://192.168.0.243/";
	#else
		static NSString* const kHHOpenBaseURLString = @"http://192.168.0.245/";
	#endif
#else
	#ifdef HH_PUBLIC_HOST_IP
		static NSString * const kHHOpenBaseURLString = @"http://122.144.130.250/";
	#else
		static NSString * const kHHOpenBaseURLString = @"http://ccs.huhoo.com/";
	#endif
#endif


@implementation HHOpenClient

+ (HHOpenClient *)sharedClient
{
    static HHOpenClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HHOpenClient alloc] initWithBaseURL:[NSURL URLWithString:kHHOpenBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text
{
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [GTMBase64  stringByEncodingData:HMAC];//base64
    return hash;
}


- (void)signInWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(int64_t uid, NSArray* cids))success failure:(void (^)(NSInteger))failure
{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kHuhooOAuthCustomerKey, @"oauth_consumer_key",
                                username, @"x_auth_username",
                                password, @"x_auth_password",
                                kHuhooOAuthMode, @"x_auth_mode",
                                nil];
    self.connected = NO;
    
    [self postPath:@"m/mob.login/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            NSDictionary *oauthItems = [JSON valueForKeyPath:@"ext"];
            if (oauthItems != nil) {
                self.oauthToken = [oauthItems objectForKey:kOauthTokenKey];
                self.oauthTokenSecret = [oauthItems objectForKey:kOauthTokenSecretKey];
                self.uid = [oauthItems objectForKey:kUidKey];
                if (self.uid != nil) {
					NSArray* cids = oauthItems[@"cids"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.oauthToken forKey:kOauthTokenKey];
                    [defaults setObject:self.oauthTokenSecret forKey:kOauthTokenSecretKey];
                    [defaults setInteger:self.uid.integerValue forKey:kUidKey];
                    [defaults setObject:username forKey:kUsernameKey];
                    [defaults setObject:password forKey:kPasswordKey];
					[defaults synchronize];
                    self.connected = YES;
                    success(self.uid.longLongValue, cids);
                }
                else{
                    failure(kRequestConnectionErrorCode);
                }
            }
            else{
                failure(kRequestConnectionErrorCode);
            }
        }
        else
        {
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
}

- (void)getUserBaseInfo:(NSInteger)uid success:(void (^)(NSDictionary*))success failure:(void (^)(NSInteger))failure
{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld", (long)uid] , @"uids",
                                self.oauthToken, @"oauth_token",
                                @"info", @"ext",
                                self.oauthTokenSecret, @"oauth_token_secret",
                                nil];
    
    [self getPath:@"api/v1/user/userinfo?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", operation.request.URL.absoluteString);
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil) {
                if (extItems.count > 0) {
                    NSDictionary* extItem = [extItems objectAtIndex:0];
                    success(extItem);
                }
                else
                {
                    failure(kRequestConnectionErrorCode);
                }
            }
        }
        else
        {
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
    
}

- (void)getUsersInfo:(NSArray *)uids success:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure
{
	NSString* uidsStr = [uids componentsJoinedByString:@","];
	NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								uidsStr , @"uids",
								self.oauthToken, @"oauth_token",
								self.oauthTokenSecret, @"oauth_token_secret",
								nil];
    
    [self getPath:@"api/v1/user/userinfo?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", operation.request.URL.absoluteString);
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil) {
                if (extItems.count > 0) {
                    success(extItems);
                }
                else
                {
                    failure(kRequestConnectionErrorCode);
                }
            }
        }
        else
        {
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
	
}

- (void)getUserInfo:(NSInteger)uid success:(void (^)(NSDictionary *dic))s failure:(void (^)(NSInteger i))f
{
	NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%ld", (long)uid] , @"uids",
								self.oauthToken, @"oauth_token",
								self.oauthTokenSecret, @"oauth_token_secret",
								nil];
    
    [self getPath:@"api/v1/user/userinfo?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@", operation.request.URL.absoluteString);
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil) {
                if (extItems.count > 0) {
                    NSDictionary* extItem = [extItems objectAtIndex:0];
                    s(extItem);
                }
                else
                {
                    f(kRequestConnectionErrorCode);
                }
            }
        }
        else
        {
            f(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        f(kRequestConnectionErrorCode);
    }];
}

- (void)getCompanysSuccess:(void (^)())success failure:(void (^)(NSInteger))failure
{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
								[HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
								@"baseinfo",@"tab",
//								cids,@"cids",
                                nil];
    
    [self getPath:@"m/mob.corps/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
//            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
//			NSMutableArray* cids = [NSMutableArray arrayWithCapacity:0];
//            for (NSInteger index = 0; index < extItems.count; index++) {
//                NSDictionary* extItem = [extItems objectAtIndex:index];
			NSDictionary* extItem = JSON[@"ext"];
                NSNumber* cid = [extItem objectForKey:@"corp_id"];
//				[cids addObject:cid];
				HHCompany* company = [HHCompany getCompanyWithId:cid.integerValue];
                if (company) {
                    company.fullname = [extItem objectForKey:@"corp_name"];
                    company.shortname = [extItem objectForKey:@"corp_short_name"];
                }
//            }
//			NSMutableArray* cToProcess = [NSMutableArray arrayWithCapacity:0];
//			for (HHCompany* com in [HHCompany companys]) {
//				if (![cids containsObject:@(com.cid)]) {
//					[cToProcess addObject:com];
//				}
//			}
//			for(HHCompany* c in cToProcess) {
//				[HHCompany removeComponyWithId:c.cid];
//			}
            success();
        }
        else
        {
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
    
}

- (void)getCompanyStruct:(int64_t)cid success:(void (^)(NSString*))success failure:(void (^)(int))failure
{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
								[HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
                                @"0", @"page",
                                @"10000", @"rowsofpage",
                                @"u/w/d", @"ref",
								@"workerinfo", @"tab",
                                nil];
    
    [self getPath:@"/m/mob.corps/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
}

- (void)getArea:(NSString *)area success:(void (^)(NSArray *))s failure:(void (^)(NSInteger))f
{
	//	http://open.huhoo.cn/api/v1/pub/area
	NSDictionary* params = [NSDictionary dictionaryWithObject:area forKey:@"area_ids"];
	[self getPath:@"api/v1/pub/area" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
		NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil) {
                if (extItems.count > 0) {
//                    NSDictionary* extItem = [extItems objectAtIndex:0];
                    s(extItems);
                }
                else
                {
                    f(kRequestConnectionErrorCode);
                }
            }
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		f(kRequestConnectionErrorCode);
	}];
}

- (void)uploadFile:(NSString *)fileName fileContent:(NSData *)data success:(void (^)())success
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHHCacheURLString]];
	NSMutableURLRequest* afRequest = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/QTService/offlinefiles.php?filename=%@", fileName] parameters:nil];
	[afRequest setHTTPBody:data];
	NSLog(@"file upload %@", afRequest.URL.absoluteString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    [operation setCompletionBlock:^{
		success();
    }];
    [operation start];
}


- (NSDictionary*)appAuthSignatureParametersWithCustomerKey:(NSString *)customerKey
{
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] init];
    [paras setObject:kHuhooOAuthCustomerKey forKey:@"oauth_consumer_key"];
    [paras setObject:kHuhooOAuthSignatureMethod forKey:@"oauth_signature_method"];
    [paras setObject:[NSString stringWithFormat:@"%d", [HHUtils randomNumber:1000 to:99999999]] forKey:@"oauth_nonce"];
    [paras setObject:[HHUtils timeStamp] forKey:@"oauth_timestamp"];
    [paras setObject:kHuhooOAuthVersion forKey:@"oauth_version"];
    [paras setObject:@"" forKey:@"oauth_callback"];
    [paras setObject:customerKey forKey:@"third_consumer_key"];
    [paras setObject:self.oauthToken forKey:@"oauth_token"];
    
    NSMutableString *tempUrl = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/oauth/auth", [HHOpenClient sharedClient].baseURL]];
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/auth", [HHOpenClient sharedClient].baseURL]];
    if (nsUrl.port != nil) {
        [tempUrl deleteCharactersInRange:[tempUrl rangeOfString:[NSString stringWithFormat:@":%d", nsUrl.port.intValue]]];
    }
    NSArray *sortKeysArray = [paras keysSortedByValueUsingSelector:@selector(compare:)];
    
    NSString *oauth_signature = [NSString stringWithFormat:@"GET&%s", [tempUrl UTF8String]];
    for (NSInteger i= 0; i<sortKeysArray.count; i++) {
        NSString* key = [sortKeysArray objectAtIndex:i];
        if (i == 0) {
            oauth_signature = [oauth_signature stringByAppendingFormat:@"%@=%@", key, [paras objectForKey:key]];
        }
        else{
            oauth_signature = [oauth_signature stringByAppendingFormat:@"&%@=%@", key, [paras objectForKey:key]];
        }
        
    }
    oauth_signature = [HHOpenClient hmac_sha1:[NSString stringWithFormat:@"%@&%@",kHuhooOAuthCustomerSecret, self.oauthTokenSecret] text:oauth_signature];
    [paras setObject:oauth_signature forKey:@"oauth_signature"];
    return paras;
}

- (void)requestAppOauthWithCustomerKey:(NSString *)customerKey success:(void (^)(NSString *, NSString *))success failure:(void (^)(NSInteger errorCode))failure
{
    NSDictionary* parameters = [self appAuthSignatureParametersWithCustomerKey:customerKey];
    
    [[HHOpenClient sharedClient] getPath:@"oauth/auth?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@", operation.responseString);
        NSLog(@"%@", operation.request.URL.absoluteString);
        NSNumber* code = [HHUtils numberIdFromJsonId:[JSON valueForKeyPath:@"code"]];
        if (code != nil && code.integerValue == 0) {
            NSDictionary *extItem = [JSON valueForKeyPath:@"ext"];
            if (extItem != nil && [extItem isKindOfClass:[NSDictionary class]]) {
                NSString* token = [extItem objectForKey:@"oauth_token"];
                NSString* tokenSecret = [extItem objectForKey:@"oauth_token_secret"];
                if (token && token.length > 0 && tokenSecret && tokenSecret.length > 0) {
                    success(token, tokenSecret);
                    return;
                }
            }
            else
            {
                failure(kRequestConnectionErrorCode);
            }
            
        }
        else
        {
            failure(code.integerValue);
        }
        NSLog(@"request app oauth failed: %@", customerKey);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request app oauth failed: %@ error:%@",customerKey, error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
}


- (NSDictionary*)signatureParasWithParas:(NSDictionary *)moreParas url:(NSString *)url method:(NSString *)method OAuthToken:(NSString *)token OAuthTokenSecret:(NSString *)tokenSecret thirdCustomerKey:(NSString *)customerKey customerSecret:(NSString *)customerSecret
{
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] initWithDictionary:moreParas];
    [paras setObject:customerKey forKey:@"third_consumer_key"];
    [paras setObject:kHuhooOAuthSignatureMethod forKey:@"oauth_signature_method"];
    [paras setObject:[NSString stringWithFormat:@"%d", [HHUtils randomNumber:1000 to:99999999]] forKey:@"oauth_nonce"];
    [paras setObject:[HHUtils timeStamp] forKey:@"oauth_timestamp"];
    [paras setObject:kHuhooOAuthVersion forKey:@"oauth_version"];
    [paras setObject:@"" forKey:@"oauth_callback"];
    [paras setObject:token forKey:@"oauth_token"];
    
    NSMutableString *tempUrl = [NSMutableString stringWithString:url];
    NSURL *nsUrl = [NSURL URLWithString:url];
    if (nsUrl.port != nil) {
        [tempUrl deleteCharactersInRange:[tempUrl rangeOfString:[NSString stringWithFormat:@":%ld", nsUrl.port.longValue]]];
    }
    NSArray *sortKeysArray = [paras keysSortedByValueUsingSelector:@selector(compare:)];
    
    NSString *oauth_signature = [NSString stringWithFormat:@"%@&%s", method, [tempUrl UTF8String]];
    for (NSInteger i= 0; i<sortKeysArray.count; i++) {
        NSString* key = [sortKeysArray objectAtIndex:i];
        if (i == 0) {
            oauth_signature = [oauth_signature stringByAppendingFormat:@"%@=%@", key, [paras objectForKey:key]];
        }
        else{
            oauth_signature = [oauth_signature stringByAppendingFormat:@"&%@=%@", key, [paras objectForKey:key]];
        }
        
    }
    oauth_signature = [HHOpenClient hmac_sha1:[NSString stringWithFormat:@"%@&%@", customerSecret, tokenSecret] text:oauth_signature];
    [paras setObject:oauth_signature forKey:@"oauth_signature"];
    return paras;
}

//- (void)regWithName:(NSString *)name account:(NSString *)account confirmCode:(NSString *)confirmCode codeId:(NSString *)codeId pwd:(NSString *)pwd ip:(NSString *)ip success:(void (^)(NSDictionary * dic))success failure:(void (^)(NSInteger i))failure
//{
//	NSDictionary* params = @{@"nickname": name, @"account":account, @"confirm_code": confirmCode, @"code_id": codeId, @"password": pwd, @"ip": ip, @"oauth_consumer_key": @"uc.huhoo.cn", @"realname": name};
//	[self postPath:@"api/v1/reg/user" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//		NSNumber* code = [JSON valueForKeyPath:@"code"];
//        if (code != nil && code.integerValue == 0) {
//            NSDictionary *extItem = [JSON valueForKeyPath:@"ext"];
//            if (extItem != nil) {
//				success(extItem);
//			}
//			else
//			{
//				failure(kRequestConnectionErrorCode);
//			}
//		} else {
//			failure(kRequestConnectionErrorCode);
//		}
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		failure(kRequestConnectionErrorCode);
//	}];
//}
//
//- (void)getConfirmCodeAndIdwithAccount:(NSString *)account option:(NSInteger)option ip:(NSString *)ip success:(void (^)(NSString *))success failure:(void (^)(NSInteger))failure
//{
//	NSString* op = option == 0 ? @"reg" : @"pwd";
//	NSDictionary* params = @{@"account": account, @"option": op, @"ip": ip};
//	[self getPath:@"api/v1/reg/confirm" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//		NSInteger code = ((NSNumber*)[JSON objectForKey:@"code"]).integerValue;
//		if (code != 0) {
//			failure(code);
//			return;
//		}
//		NSString *extItem = [HHUtils validateString:[JSON valueForKeyPath:@"ext"]];
//		if (extItem.length > 0) {
//			success(extItem);
//		} else {
//			failure(-1);
//		}
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		failure(kRequestConnectionErrorCode);
//	}];
//}
//
//- (void)resetPwdWithAccount:(NSString *)account pwd:(NSString *)pwd confirmCode:(NSString *)code codeId:(NSString *)codeId success:(void (^)())success failure:(void (^)(NSInteger))failure
//{
//	NSDictionary* params = @{@"account": account, @"confirm_code": code, @"code_id": codeId, @"password": pwd, @"oauth_consumer_key": @"uc.huhoo.cn"};
//	[self postPath:@"api/v1/reg/pwd" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//		BOOL s = [HHUtils validateNumber:[JSON valueForKey:@"ext"]].boolValue;
//		if (s) {
//			success();
//		} else {
//			failure(kRequestConnectionErrorCode);
//		}
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		failure(kRequestConnectionErrorCode);
//	}];
//}

- (NSString*)urlAbsoluteStringWithPath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    return url.absoluteString;
}

//- (void)updateReceivePushStatus:(NSDictionary*)status
//{
//    if (self.deviceToken && self.deviceToken.length > 0 && self.uid && self.oauthToken) {
//        NSMutableDictionary* params = nil;
//        if (status && status.count > 0) {
//            params = [NSMutableDictionary dictionaryWithDictionary:status];
//        }
//        if (!params) {
//            params = [[NSMutableDictionary alloc] init];
//			[params setObject:@"0" forKey:kReceiveIMNotificationKey];
//			[params setObject:@"0" forKey:kApprovalNotificationKey];
//			[params setObject:@"0" forKey:kSynergyNotificationKey];
//			[params setObject:@"0" forKey:kNoticeNotificationKey];
//        }
//        [params setObject:self.deviceToken forKey:@"devicetoken"];
//        [params setObject:[NSString stringWithFormat:@"%d", self.uid.integerValue] forKey:@"uid"];
//        NSString* path = @"/app/common/v1.0/updatedevicetoken.json";
//        NSString* url = [[HHOpenClient sharedClient] urlAbsoluteStringWithPath:path];
//        NSDictionary* paras = [self signatureParasWithParas:params url:url method:@"GET" OAuthToken:self.oauthToken OAuthTokenSecret:self.oauthTokenSecret thirdCustomerKey:kHuhooOAuthCustomerKey customerSecret:kHuhooOAuthCustomerSecret];
//        [self getPath:path parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@", operation.request.URL.absoluteString);
//            NSNumber* code = [responseObject valueForKeyPath:@"code"];
//            if (code != nil && code.integerValue == 0) {
//                NSLog(@"update deviceToken success");
//				[(HHAppDelegate*)[UIApplication sharedApplication].delegate saveAppsettings];
//            } else {
//				NSLog(@"update deviceToken failure");
//			}
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"update deviceToken failure %@", operation.request.URL.absoluteString);
//        }];
//    }
//}

//- (void)setDeviceToken:(NSString *)deviceToken
//{
//    _deviceToken = deviceToken;
//    if (!self.connected) {
//        return;
//    }
//    HHAppDelegate* d = (HHAppDelegate*)[UIApplication sharedApplication].delegate;
//    [self updateReceivePushStatus:d.settings];
//}

//+ (void)sendFeedback:(NSString *)suggestion email:(NSString *)email phone:(NSString *)phone success:(void (^)())success failure:(void (^)(NSInteger))failure
//
//{
//    if ([HHOpenClient sharedClient].oauthToken == nil ||
//        [HHOpenClient sharedClient].oauthTokenSecret  == nil) {
//        failure(kRequestConnectionErrorCode);
//    }
//    HHAccount* _sharedAccount = [HHAccount sharedAccount];
//	
//    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [HHOpenClient sharedClient].oauthToken, @"oauth_token",
//                                [HHOpenClient sharedClient].oauthTokenSecret,@"oauth_token_secret",
//                                [NSString stringWithFormat:@"%d", _sharedAccount.uid.integerValue] , @"uid",
//                                suggestion, @"suggestion",
//                                email, @"email",
//                                phone, @"telephone",
//                                nil];
//    
//    [[HHOpenClient sharedClient] getPath:@"app/uc/v1.0/suggest.json?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
//		NSInteger code = [((NSDictionary*)JSON)[@"code"] integerValue];
//		if (code == 0) {
//			success();
//		} else {
//			failure(kRequestConnectionErrorCode);
//		}
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		failure(kRequestConnectionErrorCode);
//	}];
//}

- (void)signOut
{
//    NSDictionary* pushDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kNoticeNotificationKey, @"0", kApprovalNotificationKey, @"0", kSynergyNotificationKey, @"0", kReceiveIMNotificationKey, nil];
//    [self updateReceivePushStatus:pushDic];
    self.oauthToken = nil;
    self.oauthTokenSecret = nil;
    self.uid = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kOauthTokenKey];
    [defaults setObject:@"" forKey:kOauthTokenSecretKey];
    [defaults setInteger:0 forKey:kUidKey];
    self.connected = NO;
}

@end
