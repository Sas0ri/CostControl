//
//  HHAttachController.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HHAttach.h"
#import "HHBaseViewController.h"

@interface HHAttachController : HHBaseViewController <NSURLConnectionDelegate, UIWebViewDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) HHAttach* attach;

@end
