//
//  HHWorkerChooseController.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-25.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseTableViewController.h"
#import "CMIndexBar.h"

@protocol HHWorkerChooseControllerDelegate;

typedef void (^WorkerChooseResultsBlock)(NSArray *);

@interface HHWorkerChooseController : HHBaseTableViewController<UISearchDisplayDelegate,UISearchBarDelegate,CMIndexBarDelegate>

@property (nonatomic) NSInteger cid;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, strong) NSMutableArray* selectedWorkers;
@property (nonatomic, weak) id <HHWorkerChooseControllerDelegate> delegate;
@property (copy)WorkerChooseResultsBlock completionBlock;
@property (nonatomic, strong) NSArray* candidatedWorkers;
@end

@protocol HHWorkerChooseControllerDelegate <NSObject>
@required
- (void)workerChooseController:(HHWorkerChooseController*)workerChooseController workersChoosed:(NSArray*)workersChoosed;
@end
