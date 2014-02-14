//
//  BaDetailCell.h
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (nonatomic, strong) NSDictionary* model;
@end
