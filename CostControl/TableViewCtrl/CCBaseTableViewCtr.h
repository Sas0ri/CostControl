//
//  CCBaseTableViewCtr.h
//  CostControl
//
//  Created by Sasori on 14-1-23.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCommentCell.h"

@interface CCBaseTableViewCtr : UITableViewController
@property (nonatomic, strong) NSDictionary* modelDic;
@property (nonatomic, strong) NSArray* submitArr;
@property (nonatomic, strong) NSArray* comments;
- (void)reloadData;
- (void)_reloadData;
@end
