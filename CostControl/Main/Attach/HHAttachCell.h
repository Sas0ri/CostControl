//
//  HHAttachCell.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-23.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAttach.h"

@interface HHAttachCell : UITableViewCell

@property (nonatomic, strong) HHAttach* attach;

@property (weak, nonatomic) IBOutlet UIImageView *fileIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
