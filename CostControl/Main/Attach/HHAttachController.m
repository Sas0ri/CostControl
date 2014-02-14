//
//  HHAttachController.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHAttachController.h"
#import "HHUtils.h"
#import "MBProgressHUD.h"
#import "HHUtils.h"

@interface HHAttachController ()

@property (nonatomic, retain)MBProgressHUD *HUD;
@property (nonatomic, strong)NSMutableData *webData;
@property (nonatomic)long long expectedLength;

@end

@implementation HHAttachController

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
    
    self.navigationItem.title = self.attach.fileName;
    [self loadAttach];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSString*)tmpFileName
{
    NSString *Path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filename=[Path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp.%@", self.attach.fileType]];
    return filename;
}

- (void)loadAttach
{
    if (!self.attach || ![self.attach.url isKindOfClass:[NSString class]] || self.attach.url.length <= 0) {
        return;
    }
    if ([self.attach.fileType isEqualToString:@"rar"] || [self.attach.fileType isEqualToString:@"zip"]) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法查看此类型的附件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.attach.url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        self.webData = [[NSMutableData alloc] init];
    }
	[connection start];

    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.HUD];
	self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self.HUD.delegate = self;
    [self.HUD show:YES];
    self.HUD.removeFromSuperViewOnHide = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.HUD.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    self.HUD.hidden = YES;
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setWebData:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.expectedLength = [response expectedContentLength];
    [self.webData setLength: 0];
    self.HUD.progress = [self.webData length] / (float)self.expectedLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.webData appendData:data];
	self.HUD.progress = [self.webData length] / (float)self.expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *filename = [self tmpFileName];
    if (![[NSFileManager defaultManager]createFileAtPath:filename contents:self.webData attributes:nil]) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
            return;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filename]];
    [self.webview loadRequest:request];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.webData = nil;
    self.HUD.hidden = YES;
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"附件下载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod
		 isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		// we only trust our own domain
		if ([challenge.protectionSpace.host isEqualToString:@"open.huhoo.cn"])
		{
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
