//
//  HHAccount.m
//  CostControl
//
//  Created by Sasori on 14-1-15.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "HHAccount.h"
#import "AppDelegate.h"
#import "HHDB.h"
#import "HHApprovalItemModel.h"
#import "HHOpenClient.h"
#import "HHUtils.h"
#import "HHApprovalOpenClient.h"

@interface HHAccount()
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* tokenSecret;
@end

@implementation HHAccount

+ (instancetype)sharedAccount
{
	static HHAccount* account = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		account = [HHAccount new];
	});
	return account;
}

- (void)initWhenSignInSuccess:(NSNumber*)uid
{
    self.uid = uid;
	self.hasSignedIn = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults objectForKey:kUsernameKey];
    self.password = [defaults objectForKey:kPasswordKey];
    [[HHDB sharedDB] open:uid];
    [HHApprovalItemModel initWhenSignInSuccess];
	[self getCompany];
}

- (void)getCompany
{
	[[HHOpenClient sharedClient] getCompanysSuccess:^(){
		if ([HHCompany companys].count > 0) {
            
            BOOL isCurrentCidValid = NO;
            if ([HHAccount sharedAccount].currentCid > 0) {
                for (HHCompany* company in [HHCompany companys]) {
                    if (company.cid == [HHAccount sharedAccount].currentCid) {
                        isCurrentCidValid = YES;
                    }
                }
            }
            if (!isCurrentCidValid) {
                HHCompany* company = [[HHCompany companys] objectAtIndex:0];
                [HHAccount sharedAccount].currentCid = company.cid;
            }
		}
		for (HHCompany* hc in [HHCompany companys]) {
				[hc getStructSuccess:^{
				} failure:^(int i) {
					
				}];
			
		}
	}
	failure:^(NSInteger code) {}];
}

- (void)signInSuccess:(void (^)(int8_t code))success failure:(void (^)(int8_t code))failure
{
    [[HHOpenClient sharedClient] signInWithUsername:self.username password:self.password success:^(int64_t uid, NSArray* cids) {
        [self initWhenSignInSuccess:@(uid)];
        success(0);
    } failure:^(NSInteger code) {
        failure(code);
    }];
}

- (void)signOut
{
	self.hasSignedIn = NO;
    [[HHOpenClient sharedClient] signOut];
    [HHCompany reset];
    [[HHDB sharedDB] close];
    [HHApprovalItemModel clearAllModels];
	self.currentCid = -1;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
