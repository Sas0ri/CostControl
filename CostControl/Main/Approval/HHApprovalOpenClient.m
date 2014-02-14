//
//  HHApprovalOpenClient.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalOpenClient.h"
#import "HHOpenClient.h"
#import "HHApprovalItemModel.h"
#import "HHUtils.h"
#import "HHAccount.h"
#import "HHApprovalItem.h"
#import "HHAppOauth.h"
#import "HHDB.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#define kApprovalAppId  @"100007"
#define kApprovalCustomerKey    @"100007.app.huhoo.cn"
#define kApprovalCustomerSecret    @"100007.app.huhoo.cn_"

#define kApprovalHandlePath @"checkapp.json"

#ifdef HHDEBUG
	static NSString * const kBaseUrl = @"http://192.168.0.245";
#else
	static NSString * const kBaseUrl = @"http://ccs.huhoo.com/";
#endif

@implementation HHApprovalOpenClient

+ (HHApprovalOpenClient*)sharedClient
{
    static HHApprovalOpenClient* _sharedClient = nil;
    if (_sharedClient == nil) {
        _sharedClient = [[HHApprovalOpenClient alloc] init];
    }
    return _sharedClient;
}

- (void)cancelAllRequest
{
    [[HHOpenClient sharedClient] cancelAllHTTPOperationsWithMethod:@"GET" path:[HHApprovalItemModel listPath]];
}

- (void)updateListWithModel:(HHApprovalItemModel*)model
{

	//model.latestItemId.longLongValue
	long long int newthan = model.latestItemId.longLongValue > 0 ? model.latestItemId.longLongValue: 0;
    NSDictionary *paras = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%d", 10], @"rowsofpage",
                           model.identifier, @"tab",
                           [NSString stringWithFormat:@"%lld", newthan], @"newer_than",
                           [NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
						   [HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
                           nil];
	
	AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [client getPath:@"/m/mob.lists/" parameters:paras success:^(AFHTTPRequestOperation *operation, id JSON) {
		JSON = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];
        NSNumber* code = [HHUtils numberIdFromJsonId:[JSON valueForKeyPath:@"code"]];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil && [extItems isKindOfClass:[NSArray class]]) {
                NSMutableArray* objects = [NSMutableArray arrayWithCapacity:extItems.count];
                for (NSInteger i=0; i<extItems.count; i++) {
                    NSDictionary* itemData = [extItems objectAtIndex:i];
                    HHApprovalItem* object = [[HHApprovalItem alloc] initWithData:itemData];
                    object.type = model.identifier;
                    [objects addObject:object];
                }
                [model addUpdatedItems:objects];
                return;
            }
        }
        else
        {
            NSLog(@"Approval update list error code: %@", code);
			if (code.intValue == -101) {
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错了"
																message:@"您的授权已过期，请重新登录"
															   delegate:self
													  cancelButtonTitle:@"确定"
													  otherButtonTitles:nil];
				[alert show];
				return;
			}
        }
        [model addUpdatedItems:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [model addUpdatedItems:nil];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[HHAccount sharedAccount] signOut];
	[((AppDelegate*)[UIApplication sharedApplication].delegate).navCtr popToRootViewControllerAnimated:YES];
}


- (void)loadMoreListWithModel:(HHApprovalItemModel*)model
{
    NSDictionary *paras = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%d", 10], @"rowsofpage",
                           model.identifier, @"flag",
                           [NSString stringWithFormat:@"%lld", model.oldestItemId.longLongValue], @"older_than",
                           [NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
						   [HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
                           nil];

	AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];

    [client getPath:@"/m/mob.lists/" parameters:paras success:^(AFHTTPRequestOperation *operation, id JSON) {
		JSON = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];
        NSNumber* code = [HHUtils numberIdFromJsonId:[JSON valueForKeyPath:@"code"]];
        if (code != nil && code.integerValue == 0) {
            NSArray *extItems = [JSON valueForKeyPath:@"ext"];
            if (extItems != nil && [extItems isKindOfClass:[NSArray class]]) {
                NSMutableArray* objects = [NSMutableArray arrayWithCapacity:extItems.count];
                for (NSInteger i=0; i<extItems.count; i++) {
                    NSDictionary* itemData = [extItems objectAtIndex:i];
                    HHApprovalItem* object = [[HHApprovalItem alloc] initWithData:itemData];
                    object.type = model.identifier;
                    [objects addObject:object];
                }
                [model addLoadMoreItems:objects];
                return;
            }
        }
        else
        {
            NSLog(@"Approval load more list error code: %@", code);
        }
        [model addLoadMoreItems:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [model addLoadMoreItems:nil];
    }];
    
}


- (void)loadDetail:(HHApprovalItem*)item sucess:(void (^)(id data))success failure:(void (^)(NSInteger code))failure
{
    NSDictionary *paras = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%lld", item.chkId.longLongValue], @"flid",
                           [NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
						   [HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
                           nil];

	AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [client getPath:@"/m/mob.forms/view.json" parameters:paras success:^(AFHTTPRequestOperation *operation, id JSON) {
		JSON = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];

        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code.integerValue == 0  && [[JSON valueForKeyPath:@"ext"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary* ext = [JSON valueForKeyPath:@"ext"];
//            if ([ext objectForKey:@"cot"]) {
                success(ext);
//            }
//            else{
//                NSLog(@"Load approval detail failed");
//                failure(kRequestConnectionErrorCode);
//            }
        }
        else
        {
            NSLog(@"Load approval detail failed");
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Load approval detail failed %@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
}

- (void)loadComment:(HHApprovalItem*)item sucess:(void (^)(id data))success failure:(void (^)(NSInteger))failure
{
    NSDictionary *paras = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%d", 10], @"rowsofpage",
                           [NSString stringWithFormat:@"%d", 0], @"newer_than",
                           [NSString stringWithFormat:@"%d", 0], @"older_than",
                           [NSString stringWithFormat:@"%lld", item.sqId.longLongValue], @"sqid",
                           [NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"uid",
                           [NSString stringWithFormat:@"%lld", [HHAccount sharedAccount].currentCid], @"cid",
                           nil];
    NSString* path = [[HHApprovalItemModel modelWithIdentifier:item.type] commentPath];
    NSDictionary* allParas = [[HHOpenClient sharedClient] signatureParasWithParas:paras url:[[HHOpenClient sharedClient] urlAbsoluteStringWithPath:path] method:@"GET" OAuthToken:self.oauth.token OAuthTokenSecret:self.oauth.tokenSecret thirdCustomerKey:kApprovalCustomerKey customerSecret:kApprovalCustomerSecret];
    [[HHOpenClient sharedClient] getPath:path parameters:allParas success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSNumber* code = [JSON valueForKeyPath:@"code"];
        if (code != nil && code.integerValue == 0) {
            id ext = [JSON valueForKeyPath:@"ext"];
            success(ext);
        }
        else
        {
            NSLog(@"Load approval comment failed");
            failure(code.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Load approval comment failed %@", error.localizedDescription);
        failure(kRequestConnectionErrorCode);
    }];
}

- (NSString*)handlePath
{
    return [NSString stringWithFormat:@"%@%@", kApprovalOpenPath, kApprovalHandlePath];
}


- (void)handle:(NSNumber *)sqId result:(int)result contact:(NSNumber *)contact ccContacts:(NSArray *)ccContacts comment:(NSString *)comment form:(NSArray*)form sucess:(void (^)(id))success failure:(void (^)(NSInteger))failure
{
    NSMutableDictionary* paras = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  comment, @"fm_msg",
                                  [NSString stringWithFormat:@"%lld", sqId.longLongValue], @"fl_id",
								  @"save2tasks",@"act",
								  [NSString stringWithFormat:@"%lld", [HHOpenClient sharedClient].uid.longLongValue], @"auth_openid",
								  [HHOpenClient sharedClient].oauthToken, @"auth_usertoken",
                                  [self getResultStringFromInt:result], @"fd_result", nil];
	[paras addEntriesFromDictionary:[self dicFromForm:form]];
    if (result == kApprovalHandleAgreeLastPerson) {
        [paras setObject:@"0" forKey:@"fl_towid"];
    }
    else if (result == kApprovalHandleAgreeNextPerson){
        [paras setObject:[NSString stringWithFormat:@"%lld", contact.longLongValue] forKey:@"fl_towid"];
    }
    else if (result == kApprovalHandleDisagree){
        
    }
    else if (result == kApprovalHandleBack){
        [paras setObject:[NSString stringWithFormat:@"%lld", contact.longLongValue] forKey:@"fl_towid"];
    } else if (result == kApprovalHandleReply) {
		[paras setObject:[NSString stringWithFormat:@"%lld", contact.longLongValue] forKey:@"fl_towid"];
	}
    
//    if (ccContacts.count > 0) {
//        NSNumber* wid = [ccContacts objectAtIndex:0];
//        NSString *ccWids = [NSString stringWithFormat:@"%lld", wid.longLongValue];
//        for (NSInteger i=1; i<ccContacts.count; i++) {
//            wid = [ccContacts objectAtIndex:i];
//            ccWids = [NSString stringWithFormat:@"%@,%lld", ccWids, wid.longLongValue];
//        }
//        [paras setObject:ccWids forKey:@"cc_ids"];
//    }
//    NSString* path = [self handlePath];
	if (ccContacts.count > 0) {
		NSString* ccs = [ccContacts componentsJoinedByString:@","];
		[paras setObject:ccs forKey:@"fl_ccwid"];
	}
	NSString* path = @"/m/mob.forms/";
//    NSDictionary* allParas = [[HHOpenClient sharedClient] signatureParasWithParas:paras url:[[HHOpenClient sharedClient] urlAbsoluteStringWithPath:path] method:@"POST" OAuthToken:self.oauth.token OAuthTokenSecret:self.oauth.tokenSecret thirdCustomerKey:kApprovalCustomerKey customerSecret:kApprovalCustomerSecret];

	AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
	client.parameterEncoding = AFFormURLParameterEncoding;
    [client postPath:path parameters:paras success:^(AFHTTPRequestOperation *operation, id JSON) {
		JSON = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];
        NSNumber* code = [JSON valueForKeyPath:@"code"];
		NSLog(@"text :%@", JSON[@"text"]);
        if (code != nil && code.integerValue == 0) {
			success(code);
//            NSNumber* ext = [JSON valueForKeyPath:@"ext"];
//            if (ext.integerValue == 1) {
//                success(ext);
//            }
//            else
//            {
//                failure(-1);
//            }
        }
        else
        {
            failure(-1);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure(-1);
    }];
    
}

- (NSString*)getResultStringFromInt:(NSInteger)rint
{
	switch (rint) {
		case kApprovalHandleAgreeLastPerson:
			return @"agree2over";
			break;
		case kApprovalHandleAgreeNextPerson:
			return @"agree2next";
			break;
		case kApprovalHandleDisagree:
			return @"disagree2over";
			break;
		case kApprovalHandleBack:
			return @"back2next";
			break;
		case kApprovalHandleReply:
			return @"reply2next";
			break;
		default:
			break;
	}
	return nil;
}

- (NSDictionary*)dicFromForm:(NSArray*)form
{
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	for (int i = 0; i < form.count; i++) {
		NSDictionary* dic = form[i];
		for (NSString* key in [dic allKeys]) {
			if ([key isEqualToString:@"id"]) {
				NSString* ikey = [NSString stringWithFormat:@"detail[%d][extid]",i];
				result[ikey] = dic[key];
			} else {
				NSString* ikey = [NSString stringWithFormat:@"detail[%d][%@]",i,key];
				result[ikey] = dic[key];
			}
		}
	}
	return result;
}

- (void)requestOauth
{
    self.oauth = [[HHDB sharedDB] loadAppOauthsWithUid:[HHOpenClient sharedClient].uid customerKey:[self customerKey]];
    if (![self isOauthRequested]) {
        [[HHOpenClient sharedClient] requestAppOauthWithCustomerKey:kApprovalCustomerKey success:^(NSString *oauthToken, NSString *oauthTokenSecret) {
            self.oauth = [[HHAppOauth alloc] init];
            self.oauth.token = [oauthToken copy];
            self.oauth.tokenSecret = [oauthTokenSecret copy];
            self.oauth.customerKey = [self.customerKey copy];
            self.oauth.uid = [NSNumber numberWithLong:[HHOpenClient sharedClient].uid.longValue];
            [[HHDB sharedDB] insertAppOauth:self.oauth];
            
            NSLog(@"Request approval oauth success");
        } failure:^(NSInteger errorCode) {
            NSLog(@"Request approval oauth failed");
        }];
    }
}

- (NSString*)customerKey
{
    return kApprovalCustomerKey;
}

- (BOOL)isOauthRequested
{
    return (self.oauth != nil);
}


@end
