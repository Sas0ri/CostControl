//
//  HHOpenClient.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-7.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "AFHTTPClient.h"

#define kRequestConnectionErrorCode     -1000
#define kOauthTokenInvalidErrorCode     -2000
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

#ifdef HHDEBUG
	#if HHDEBUG_ON_243
		static NSString* const kHHCacheURLString = @"http://192.168.0.243/";
	#else
		static NSString* const kHHCacheURLString = @"http://192.168.0.245/";
	#endif
#else
	#ifdef HH_PUBLIC_HOST_IP
		static NSString * const kHHCacheURLString = @"http://122.144.130.250/";
	#else
		static NSString * const kHHCacheURLString = @"http://ccs.huhoo.com/";
	#endif
#endif


@interface HHOpenClient : AFHTTPClient

@property (nonatomic, strong)NSString *oauthToken;
@property (nonatomic, strong)NSString *oauthTokenSecret;
@property (nonatomic, strong)NSNumber *uid;
@property (nonatomic, strong)NSString *deviceToken;
@property (nonatomic) BOOL connected;

+ (HHOpenClient *)sharedClient;
+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text;
- (void)signInWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(int64_t uid, NSArray* cids))success failure:(void (^)(NSInteger))failure;
- (void)signOut;
- (void)getUserBaseInfo:(NSInteger)uid success:(void (^)(NSDictionary*))success failure:(void (^)(NSInteger))failure;
- (void)getUsersInfo:(NSArray*)uids success:(void (^)(NSArray*))success failure:(void (^)(NSInteger))failure;
- (void)getCompanysSuccess:(void (^)())success failure:(void (^)(NSInteger))failure;
- (void)getCompanyStruct:(int64_t)cid success:(void (^)(NSString*))success failure:(void (^)(int))failure;
//- (void)uploadImage:(UIImage*)img withName:(NSString*)imgName success:(void (^)())success;
- (void)getUserInfo:(NSInteger)uid success:(void (^)(NSDictionary* dic))s failure:(void (^)(NSInteger i))f;
//- (void)updateReceivePushStatus:(NSDictionary*)status;
//+ (void)sendFeedback:(NSString *)suggestion email:(NSString *)email phone:(NSString *)phone success:(void (^)())success failure:(void (^)(NSInteger))failure;
- (NSString*)urlAbsoluteStringWithPath:(NSString*)path;

- (void)requestAppOauthWithCustomerKey:(NSString*)customerKey success:(void (^)(NSString* oauthToken, NSString* oauthTokenSecret))success failure:(void (^)(NSInteger errorCode))failure;
- (NSDictionary*)appAuthSignatureParametersWithCustomerKey:(NSString *)customerKey;
- (NSDictionary*)signatureParasWithParas:(NSDictionary *)moreParas url:(NSString *)url method:(NSString *)method OAuthToken:(NSString *)token OAuthTokenSecret:(NSString *)tokenSecret thirdCustomerKey:(NSString *)customerKey customerSecret:(NSString *)customerSecret;
//- (void)getArea:(NSString*)area success:(void (^)(NSArray* areas))s failure:(void (^)(NSInteger i))f;
//- (void)uploadFile:(NSString*)fileName fileContent:(NSData*)data success:(void (^)())success;
//- (void)regWithName:(NSString*)name account:(NSString*)account confirmCode:(NSString*)confirmCode codeId:(NSString*)codeId pwd:(NSString*)pwd ip:(NSString*)ip success:(void (^)(NSDictionary* dic))success failure:(void (^)(NSInteger i))failure;
//option: 0为注册，1为找回密码
//- (void)getConfirmCodeAndIdwithAccount:(NSString*)account option:(NSInteger)option ip:(NSString*)ip success:(void (^)(NSString* codeId))success failure:(void (^)(NSInteger i))failure;
//- (void)resetPwdWithAccount:(NSString*)account pwd:(NSString*)pwd confirmCode:(NSString*)code codeId:(NSString*)codeId success:(void (^)())success failure:(void (^)(NSInteger i))failure;;
@end
