//
//  ConfirmCell.h
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICModel.h"

@protocol ConfirmCellDelegate <NSObject>

- (void)textDidConfirm:(NSString*)text cell:(UITableViewCell*)cell;

@end

@interface ConfirmCell : UITableViewCell
@property (nonatomic, weak) id<ConfirmCellDelegate> delegate;
@property (nonatomic, strong) PICModel* model;
@end
