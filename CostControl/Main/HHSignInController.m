//
//  HHSignInController.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-6.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHSignInController.h"
#import "HHAccount.h"
#import "HHOpenClient.h"
#import "NINavigationAppearance.h"
#import "HHGuideViewController.h"

@interface HHSignInController ()

@property (nonatomic, strong)MBProgressHUD* HUD;

@end

@implementation HHSignInController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NINavigationAppearance pushAppearanceForNavigationController:self.navigationController];
    if ([self.navigationController.navigationBar
         respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 50, 0, 50);
		UIImage* bg = [self resizeImage:[UIImage imageNamed:@"NavBar"]];
        [self.navigationController.navigationBar setBackgroundImage:[bg resizableImageWithCapInsets:insets]
                                                      forBarMetrics:UIBarMetricsDefault];
		[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userNameTextField.text = [defaults objectForKey:kCurrentAccountNameKey];
    self.passwordTextField.text = [defaults objectForKey:kCurrentAccountPasswordKey];
}

- (UIImage*)resizeImage:(UIImage*)image
{
	UIGraphicsBeginImageContext(CGSizeMake(320, 44));
	[image drawInRect:CGRectMake(0, -1, 320, 45)];
	UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userNameTextField.text = [defaults objectForKey:kUsernameKey];
    self.passwordTextField.text = [defaults objectForKey:kPasswordKey];
    if ([HHOpenClient sharedClient].connected) {
        [self performSegueWithIdentifier:@"SignIn2Home" sender:self];
    }
	
//	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
//    NSString* userVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"version"];
//    if (![userVersion isEqualToString:appVersion])
//    {
//        HHGuideViewController* guide = [[HHGuideViewController alloc] initWithNibName:@"HHGuideViewController" bundle:nil];
//        [self presentViewController:guide animated:NO completion:^{
//            
//        }];
//    }
}

//—-before the View window disappear—-
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//—-when the user taps on the return key on the keyboard—-
-(BOOL) textFieldShouldReturn:(UITextField *) textFieldView {
    if (textFieldView == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textFieldView == self.passwordTextField){
        [textFieldView resignFirstResponder];
        [self signIn:nil];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			cell.backgroundColor = [UIColor clearColor];
			break;
		case 1:
		case 2:
			cell.backgroundColor = [UIColor whiteColor];
			break;
		default:
			break;
	}
}

- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setSignInButton:nil];
    [self setHUD:nil];
    [super viewDidUnload];
}

- (IBAction)signIn:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (self.userNameTextField.text.length == 0) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
	if (self.passwordTextField.text.length < 6) {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码过短" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
	}
    [HHAccount sharedAccount].username = self.userNameTextField.text;
    [HHAccount sharedAccount].password = self.passwordTextField.text;
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self.HUD.delegate = self;
    [self.HUD show:YES];
    
    [[HHAccount sharedAccount] signInSuccess:^(int8_t code) {
        [self.HUD hide:YES];
        [self.HUD removeFromSuperview];
        self.HUD = nil;
        [self performSegueWithIdentifier:@"SignIn2Home" sender:self];
    } failure:^(int8_t code) {
        [self.HUD hide:YES];
        [self.HUD removeFromSuperview];
        self.HUD = nil;
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败，用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	if (textField == self.userNameTextField) {
		self.passwordTextField.text = @"";
	}
	return YES;
}

@end
