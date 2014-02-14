//
//  HHApprovalItemModel.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHApprovalItem.h"
#import "HHOAModel.h"

#define HHApprovalModelItemChangedNotification @"HHApprovalModelItemChangedNotification"
#define HHApprovalModelItemUpdatedNotification @"HHApprovalModelItemUpdatedNotification"
#define HHApprovalModelItemLoadedMoreNotification @"HHApprovalModelItemLoadedMoreNotification"
#define HHApprovalModelItemRemovedNotification @"HHApprovalModelItemRemovedNotification"

#define HHApprovalModelIdentifierKey @"HHApprovalModelIdentifierKey"
#define HHApprovalModelItemChangedTypeKey @"HHApprovalModelItemChangedTypeKey"

#define kApprovalWaitIdentifier   @"taskswait"
#define kApprovalOverIdentifier    @"tasksreceive"
#define kApprovalMineIdentifier         @"minewait"
#define kApprovalCCIdentifier         @"minecctome"


///////Open path
#define kApprovalOpenPath             @"app/100007/v1.0/"
#define kApprovalOpenListPath             @"list.json"
#define kApprovalOpenDetailPath           @"view.json"
#define kApprovalOpenCommentPath          @"comment.json"

@protocol HHApprovalItemModelDelegate;

@interface HHApprovalItemModel : HHOAModel

@property (nonatomic, strong)NSMutableArray* items;
@property (nonatomic, strong)NSDate* lastUpdateTime;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) id<HHApprovalItemModelDelegate> delegate;
@property (nonatomic) BOOL isUpdating;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic) BOOL clearBeforeUpdate;


- (id)initWithIdentifier:(NSString*)identifier;
+ (NSDictionary*)allModels;
+ (HHApprovalItemModel*)modelWithIdentifier:(NSString*)identifier;
+ (void)initWhenSignInSuccess;
+ (void)clearAllModels;

- (void)update;
- (void)loadMore;
- (void)clear;

- (NSNumber*)latestItemId;
- (NSNumber*)oldestItemId;
- (NSString*)listPath;
+ (NSString*)listPath;
- (NSString*)detailPath;
- (NSString*)commentPath;
- (void)addItems:(NSArray*)objects;
- (void)addUpdatedItems:(NSArray*)objects;
- (void)addLoadMoreItems:(NSArray*)objects;
- (void)removeItem:(HHApprovalItem*)item;


@end

@protocol HHApprovalItemModelDelegate <NSObject>

- (void)approvalItemModel:(HHApprovalItemModel*)model itemListUpdated:(NSInteger)itemCount;
- (void)approvalItemModel:(HHApprovalItemModel*)model itemListMoreLoaded:(NSInteger)itemCount;

@end
