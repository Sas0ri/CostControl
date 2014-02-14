//
//  HHWorkerChooseCell.h
//  Huhoo
//
//  Created by Sasori on 13-4-11.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHRoundImageView.h"

@interface HHWorkerChooseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HHRoundImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSNumber* wid;
@property (nonatomic, strong) NSString* avatarUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* dept;
@property (nonatomic, weak) IBOutlet UILabel* deptLabel;

- (void)showSelectedImage:(BOOL)selected;

@end
