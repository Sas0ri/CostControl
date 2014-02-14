//
//  HHSignInController.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-6.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define kCurrentAccountNameKey  @"CurrentAccountName"
#define kCurrentAccountPasswordKey  @"CurrentAccountPassword"

@interface HHSignInController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signIn:(id)sender;
@end
