//
//  HHApprovalHandleController.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-24.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTouchView.h"
#import "HEBubbleView.h"
#import "CPTextViewPlaceholder.h"
#import "HHApprovalItem.h"
#import "MBProgressHUD.h"

@interface HHApprovalHandleController : UIViewController <HEBubbleViewDataSource, HEBubbleViewDelegate,HHTouchViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) HHApprovalItem* item;
@property (nonatomic, strong) NSNumber* handleResult;
@property (nonatomic, strong) NSNumber* contactWid;
@property (nonatomic, strong) NSMutableArray* ccContactsWid;
@property (weak, nonatomic) IBOutlet UIView *contactsView;
@property (weak, nonatomic) IBOutlet UIView *ccContactsView;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;
@property (weak, nonatomic) IBOutlet UIButton *addCCContactButton;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccContactLabel;
@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *commentTextView;
@property (nonatomic, strong) NSArray* submitList;
@property (nonatomic, strong) NSArray* candidateWorkers;
@end
