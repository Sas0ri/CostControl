//
//  CCHeaderView1.h
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCompanyCell.h"
#import "CCGeneralCell.h"
#import "CCTypeCell.h"

#define CompanyId @"CCCompanyCell"
#define GeneralId @"CCGeneralCell"
#define TypeId    @"CCTypeCell"

@interface CCHeaderView1 : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary* modelDic;
- (CCGeneralCell*)getGeneralCell;
- (CCTypeCell*)getTypeCell;
- (CGFloat)heightForModel:(NSDictionary*)modelDic;
@end
