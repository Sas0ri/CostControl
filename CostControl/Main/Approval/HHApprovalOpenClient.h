//
//  HHApprovalOpenClient.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHApprovalItemModel.h"
#import "HHApprovalItem.h"
#import "HHAppOauth.h"

#define kApprovalHandleAgreeLastPerson  2
#define kApprovalHandleAgreeNextPerson  1
#define kApprovalHandleDisagree         3
#define kApprovalHandleBack             4
#define kApprovalHandleReply			5

@interface HHApprovalOpenClient : NSObject  <UIAlertViewDelegate>

@property (nonatomic, strong)HHAppOauth *oauth;

+ (HHApprovalOpenClient*)sharedClient;
- (void)cancelAllRequest;
- (void)updateListWithModel:(HHApprovalItemModel*)model;
- (void)loadMoreListWithModel:(HHApprovalItemModel*)model;
- (void)loadDetail:(HHApprovalItem*)item sucess:(void (^)(id data))success failure:(void (^)(NSInteger code))failure;
- (void)loadComment:(HHApprovalItem*)item sucess:(void (^)(id data))success failure:(void (^)(NSInteger))failure;
- (void)handle:(NSNumber*)sqId result:(int)result contact:(NSNumber*)contact ccContacts:(NSArray*)ccContacts comment:(NSString*)comment form:(NSArray*)form sucess:(void (^)(id data))success failure:(void (^)(NSInteger))failure;
- (void)requestOauth;
- (NSString*)customerKey;
- (BOOL)isOauthRequested;

@end
