//
//  DetailCell.h
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailCellDelegate <NSObject>
- (void)textDidConfirm:(NSString*)text cell:(UITableViewCell*)cell;
@end

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (nonatomic, strong) id model;
@property (nonatomic, weak) id<DetailCellDelegate> delegate;
@end
