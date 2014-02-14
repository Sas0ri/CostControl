//
//  ConfirmCell.h
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDModel.h"

@protocol DrawBackDelegate <NSObject>

- (void)textDidConfirm:(NSString*)text cell:(UITableViewCell*)cell;

@end

@interface DrawBackCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong) PDModel* model;
@property (nonatomic, weak) id<DrawBackDelegate> delegate;
@end
