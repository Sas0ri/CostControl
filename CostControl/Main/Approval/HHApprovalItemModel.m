//
//  HHApprovalItemModel.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalItemModel.h"
#import "HHApprovalItem.h"
#import "HHApprovalOpenClient.h"
#import "HHAccount.h"

@implementation HHApprovalItemModel


- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.clearBeforeUpdate = YES;
    }
    return self;
}

- (NSMutableArray*)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

+ (NSDictionary*)allModels
{
    static NSDictionary* globalApprovalAllModels = nil;
    if (globalApprovalAllModels == nil) {
        HHApprovalItemModel* unHandle = [[HHApprovalItemModel alloc] initWithIdentifier:kApprovalWaitIdentifier];
        HHApprovalItemModel* handled = [[HHApprovalItemModel alloc] initWithIdentifier:kApprovalOverIdentifier];
        HHApprovalItemModel* my = [[HHApprovalItemModel alloc] initWithIdentifier:kApprovalMineIdentifier];
        HHApprovalItemModel* cc = [[HHApprovalItemModel alloc] initWithIdentifier:kApprovalCCIdentifier];
        globalApprovalAllModels = [NSDictionary dictionaryWithObjectsAndKeys:unHandle, unHandle.identifier, handled, handled.identifier, my, my.identifier, cc, cc.identifier, nil];
    }
    return globalApprovalAllModels;
}

+ (HHApprovalItemModel*)modelWithIdentifier:(NSString *)identifier
{
    return [[HHApprovalItemModel allModels] objectForKey:identifier];
}

+ (void)initWhenSignInSuccess
{
    for (HHApprovalItemModel* model in [HHApprovalItemModel allModels].allValues) {
        [[NSNotificationCenter defaultCenter] addObserver:model selector:@selector(currentCompanyChanged:) name:HHCurrentCompanyChangedNotification object:[HHAccount sharedAccount]];
    }
    
}

+ (void)clearAllModels
{
    for (HHApprovalItemModel* model in [HHApprovalItemModel allModels].allValues) {
        [model clear];
    }
}

- (void)currentCompanyChanged:(NSNotification *)info
{
    [[HHApprovalOpenClient sharedClient] cancelAllRequest];
    NSDictionary* dic = info.userInfo;
    NSNumber* cid = [dic objectForKey:HHCurrentCompanyKey];
    NSLog(@"Current company cid: %lld update approval", cid.longLongValue);
    [self clear];
    if ([self.identifier isEqualToString:kApprovalWaitIdentifier]) {
        [self update];
    }
}

- (void)clear
{
    [self.items removeAllObjects];
    self.isUpdating = NO;
    self.isLoadingMore = NO;
    self.lastUpdateTime = nil;
}

- (NSInteger)count
{
    return self.items.count;
}

- (NSArray*)topIndexItems:(NSInteger)count
{
    NSMutableArray* indexItems = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger index = 0; index < self.items.count; index++) {
        HHApprovalItem* item = [self.items objectAtIndex:index];
        if (item) {
            HHOACellIndexItem* cellIndexItem = [[HHOACellIndexItem alloc] init];
            cellIndexItem.title = item.sqName;
            cellIndexItem.subTitle = item.workerName;
            [indexItems addObject:cellIndexItem];
            if (indexItems.count >= count) {
                break;
            }
        }
    }
    if (indexItems.count == 0) {
        return nil;
    }
    return indexItems;
}

- (void)update
{
    if (self.isUpdating) {
        NSLog(@"approval updating");
        return;
    }
    self.isUpdating = YES;
    if (self.lastUpdateTime == nil) {
        self.clearBeforeUpdate = YES;
    }
    else
    {
        NSTimeInterval interVal = [self.lastUpdateTime timeIntervalSinceNow];
        if(interVal < -60* 60)
        {
            self.clearBeforeUpdate = YES;
        }
    }
    [[HHApprovalOpenClient sharedClient] updateListWithModel:self];
}

- (void)loadMore
{
    if (self.isLoadingMore) {
        return;
    }
    self.isLoadingMore = YES;
    [[HHApprovalOpenClient sharedClient] loadMoreListWithModel:self];
}

- (void)updateIfNeed
{
    if (self.isUpdating) {
        return;
    }
    if (self.lastUpdateTime == nil) {
        [self update];
    } else
    {
        NSTimeInterval interVal = [self.lastUpdateTime timeIntervalSinceNow];
        if (interVal < -60*30) {
            [self update];
        }
        
    }
}

- (NSNumber*)latestItemId
{
    if (self.items.count > 0 && !self.clearBeforeUpdate) {
        HHApprovalItem* item = [self.items objectAtIndex:0];
		if ([self.identifier isEqualToString:kApprovalWaitIdentifier] || [self.identifier isEqualToString:kApprovalMineIdentifier]) {
			return item.chkId;
		}
		if ([self.identifier isEqualToString:kApprovalCCIdentifier]) {
			return item.fcId;
		}
        return item.fdId;
    }
    return nil;
}

- (NSNumber*)oldestItemId
{
    if (self.items.count > 0) {
        HHApprovalItem* item = [self.items objectAtIndex:self.items.count-1];
		if ([self.identifier isEqualToString:kApprovalWaitIdentifier] || [self.identifier isEqualToString:kApprovalMineIdentifier]) {
			return item.chkId;
		}
		if ([self.identifier isEqualToString:kApprovalCCIdentifier]) {
			return item.fcId;
		}
        return item.fdId;
    }
    return nil;
}

+ (NSString*)listPath
{
    return [NSString stringWithFormat:@"%@%@", kApprovalOpenPath, kApprovalOpenListPath];
}

- (NSString*)listPath
{
    return [HHApprovalItemModel listPath];
}

- (NSString*)detailPath
{
    return [NSString stringWithFormat:@"%@%@", kApprovalOpenPath, kApprovalOpenDetailPath];
}

- (NSString*)commentPath
{
    return [NSString stringWithFormat:@"%@%@", kApprovalOpenPath, kApprovalOpenCommentPath];
}

- (void)addItems:(NSArray *)objects
{
    if (objects.count <= 0) {
        return;
    }
    NSMutableArray* tempItems = [NSMutableArray arrayWithArray:self.items];
    for (HHApprovalItem* item in objects) {
        for (NSInteger index = 0; index < self.items.count; index++) {
            HHApprovalItem* oldItem = [self.items objectAtIndex:index];
            if ([oldItem.chkId isEqualToNumber:item.chkId]) {
                [tempItems removeObject:oldItem];
                break;
            }
        }
    }
    [tempItems addObjectsFromArray:objects];
//	[tempItems filterUsingPredicate:[NSPredicate predicateWithFormat:@"copId = %@",@([HHAccount sharedAccount].currentCid)]];
    self.items = [NSMutableArray arrayWithArray:[tempItems sortedArrayUsingComparator:^(id obj1,id obj2)
                                                 {
                                                     HHApprovalItem* item1 = obj1;
                                                     HHApprovalItem* item2 = obj2;
                                                     return [item2.primaryDate compare:item1.primaryDate];
                                                 }]];
}

- (void)removeItem:(HHApprovalItem*)item
{
    for (HHApprovalItem* temp in self.items) {
        if ([temp.chkId isEqualToNumber:item.chkId]) {
            [self.items removeObject:temp];
            [[NSNotificationCenter defaultCenter] postNotificationName:HHApprovalModelItemChangedNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier, HHApprovalModelIdentifierKey, HHApprovalModelItemRemovedNotification, HHApprovalModelItemChangedTypeKey, nil]];
            return;
        }
    }
}


- (void)addUpdatedItems:(NSArray *)objects
{
    if (self.clearBeforeUpdate) {
        [self clear];
        self.clearBeforeUpdate = NO;
    }
    self.isUpdating = NO;
    
    self.lastUpdateTime = [NSDate date];
    [self addItems:objects];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(approvalItemModel:itemListUpdated:)]) {
        [self.delegate approvalItemModel:self itemListUpdated:objects.count];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HHApprovalModelItemChangedNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier, HHApprovalModelIdentifierKey, HHApprovalModelItemUpdatedNotification, HHApprovalModelItemChangedTypeKey, nil]];
    
}

- (void)addLoadMoreItems:(NSArray *)objects
{
    self.isLoadingMore = NO;

    [self addItems:objects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(approvalItemModel:itemListMoreLoaded:)]) {
        [self.delegate approvalItemModel:self itemListMoreLoaded:objects.count];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HHApprovalModelItemChangedNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier, HHApprovalModelIdentifierKey, HHApprovalModelItemLoadedMoreNotification, HHApprovalModelItemChangedTypeKey, nil]];
}

@end
