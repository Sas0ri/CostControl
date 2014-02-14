//
//  BudgetCell.h
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetModel.h"

@protocol BudgetCellDelegate <NSObject>

- (void)budgetDidChange:(NSString*)budget cell:(UITableViewCell*)cell;

@end

@interface BudgetCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UITextField *budgetField;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (nonatomic, assign) double sum;
@property (nonatomic, weak) id<BudgetCellDelegate> delegate;
@property (nonatomic, strong) BudgetDetailModel* model;

@end
