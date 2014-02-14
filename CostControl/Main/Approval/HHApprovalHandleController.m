//
//  HHApprovalHandleController.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-24.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalHandleController.h"
#import "HHUtils.h"
#import "HHApprovalOpenClient.h"
#import "HHCompany.h"
#import "HHAccount.h"
#import "HHWorkerChooseController.h"
#import "MBProgressHUD.h"
#import "HHApprovalController.h"
#import "HHApprovalItemModel.h"

#define kApprovalContactViewMinHeight   44
#define kApprovalContactViewMaxHeight   66
#define kApprovalContactBubbleViewMinHeight 24
#define kApprovalContactBubbleViewMaxHeight 46

@interface HHApprovalHandleController ()

@property (nonatomic, strong) HHTouchView* touchView;
@property (strong, nonatomic) HEBubbleView* contactsBubbleView;
@property (strong, nonatomic) HEBubbleView* ccContactsBubbleView;

@property (strong, nonatomic) UIView* contactsViewBottomLine1;
@property (strong, nonatomic) UIView* contactsViewBottomLine2;

@property (strong, nonatomic) UIView* ccContactsViewBottomLine1;
@property (strong, nonatomic) UIView* ccContactsViewBottomLine2;

@property (nonatomic, strong) MBProgressHUD* HUD;
@property (nonatomic) BOOL handleSuccess;

@property (nonatomic, strong) UIButton* backButton;


@end

@implementation HHApprovalHandleController

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
	// Do any additional setup after loading the view.
    
    self.backButton = [HHUtils navLeftButtonWithTitle:@"返回"];
	[self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *button = [HHUtils navDoneButton];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    self.commentTextView.placeholder = @"请输入您的意见";
    self.commentTextView.textColor = [UIColor darkTextColor];
    
    if (self.handleResult) {
        switch (self.handleResult.integerValue) {
            case kApprovalHandleAgreeLastPerson:
                self.navigationItem.title = @"同意并结束";
                self.contactsView.hidden = YES;
                self.commentTextView.text = @"同意";
                break;
            case kApprovalHandleAgreeNextPerson:
                self.navigationItem.title = @"同意并提交";
                self.contactsView.hidden = NO;
                if (self.contactWid) {
                    self.addContactButton.hidden = YES;
                }
                self.contactLabel.text = @"审批:";
                self.commentTextView.text = @"同意";
                break;
            case kApprovalHandleDisagree:
                self.navigationItem.title = @"不同意";
                self.contactsView.hidden = YES;
                self.commentTextView.text = @"不同意";
                break;
            case kApprovalHandleBack:
                self.navigationItem.title = @"回退";
                self.contactsView.hidden = NO;
                self.contactLabel.text = @"回退:";
                self.ccContactsView.hidden = YES;
                self.commentTextView.text = @"回退";
                break;
			case kApprovalHandleReply:
                self.navigationItem.title = @"回复";
                self.contactsView.hidden = NO;
                self.contactLabel.text = @"回复:";
                self.ccContactsView.hidden = YES;
				self.addContactButton.hidden = YES;
                self.commentTextView.text = @"回复";
                break;
            default:
                break;
        }
    }
    if (!self.contactsView.hidden) {
        CGFloat x = self.contactLabel.frame.origin.x + self.contactLabel.frame.size.width + 8;
        CGRect frameBubbleView = CGRectMake(x, (self.contactsView.frame.size.height - kApprovalContactBubbleViewMinHeight)/2, self.addContactButton.frame.origin.x - 8 - x, kApprovalContactBubbleViewMinHeight);
        self.contactsBubbleView = [[HEBubbleView alloc] initWithFrame:frameBubbleView];
        self.contactsBubbleView.alwaysBounceVertical = NO;
        self.contactsBubbleView.bubbleDataSource = self;
        self.contactsBubbleView.bubbleDelegate = self;
        
        self.contactsBubbleView .selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self.contactsView addSubview:self.contactsBubbleView];
        
        x = self.contactLabel.frame.origin.x;
        CGFloat width = self.addContactButton.frame.origin.x + self.addContactButton.frame.size.width - x;
        CGFloat y = self.contactsView.frame.size.height - 2.0f;
        self.contactsViewBottomLine1 = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 1.0f)];
		self.contactsViewBottomLine1.backgroundColor = [UIColor colorWithRed:(160.0f/255.0f) green:(160.0f/255.0f) blue:(160.0f/255.0f) alpha:1.0f];
		[self.contactsView addSubview:self.contactsViewBottomLine1];
		
		self.contactsViewBottomLine2 = [[UIView alloc] initWithFrame:CGRectMake(x, y+1.0f, width, 1.0f)];
		self.contactsViewBottomLine2.backgroundColor = [UIColor colorWithRed:(192.0f/255.0f) green:(192.0f/255.0f) blue:(192.0f/255.0f) alpha:1.0f];
		[self.contactsView addSubview:self.contactsViewBottomLine2];
		
		if (self.handleResult.integerValue == kApprovalHandleReply) {
			self.contactWid = self.candidateWorkers[0];
		}
    }
    if (!self.ccContactsView.hidden) {
        self.ccContactsWid = [[NSMutableArray alloc] init];
        CGFloat x = self.ccContactLabel.frame.origin.x + self.ccContactLabel.frame.size.width + 8;
        CGRect frameBubbleView = CGRectMake(x, (self.contactsView.frame.size.height - kApprovalContactBubbleViewMinHeight)/2, self.addCCContactButton.frame.origin.x - 8 - x, kApprovalContactBubbleViewMinHeight);
        self.ccContactsBubbleView = [[HEBubbleView alloc] initWithFrame:frameBubbleView];
        self.ccContactsBubbleView.alwaysBounceVertical = NO;
        self.ccContactsBubbleView.bubbleDataSource = self;
        self.ccContactsBubbleView.bubbleDelegate = self;
        
        self.ccContactsBubbleView .selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self.ccContactsView addSubview:self.ccContactsBubbleView];
        
        x = self.ccContactLabel.frame.origin.x;
        CGFloat width = self.addCCContactButton.frame.origin.x + self.addCCContactButton.frame.size.width - x;
        CGFloat y = self.ccContactsView.frame.size.height - 2.0f;
        self.ccContactsViewBottomLine1 = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 1.0f)];
		self.ccContactsViewBottomLine1.backgroundColor = [UIColor colorWithRed:(160.0f/255.0f) green:(160.0f/255.0f) blue:(160.0f/255.0f) alpha:1.0f];
		[self.ccContactsView addSubview:self.ccContactsViewBottomLine1];
		
		self.ccContactsViewBottomLine2 = [[UIView alloc] initWithFrame:CGRectMake(x, y+1.0f, width, 1.0f)];
		self.ccContactsViewBottomLine2.backgroundColor = [UIColor colorWithRed:(192.0f/255.0f) green:(192.0f/255.0f) blue:(192.0f/255.0f) alpha:1.0f];
		[self.ccContactsView addSubview:self.ccContactsViewBottomLine2];
    }
	[self.contactsBubbleView reloadData];
    [self updateSubViewsFrame:NO];
    
}


- (void)backAction:(id)sender
{
	[self.commentTextView resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.commentTextView resignFirstResponder];
    NSNumber* contact = self.contactWid;
    NSString* comment = self.commentTextView.text;
    switch (self.handleResult.integerValue) {
        case kApprovalHandleAgreeLastPerson:
            if (comment.length == 0) {
                comment = @"同意";
            }
            contact = nil;
            break;
        case kApprovalHandleAgreeNextPerson:
            if (!contact) {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"审批人不能为空" message:@"同意并提交时必须选择审批人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (comment.length == 0) {
                comment = @"同意";
            }
            
            break;
        case kApprovalHandleDisagree:
            if (comment.length == 0) {
                comment = @"不同意";
            }
            contact = nil;
            break;
        case kApprovalHandleBack:
            if (!contact) {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"回退人不能为空" message:@"回退时必须选择回退人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (comment.length == 0) {
                comment = @"回退";
            }
            break;
        default:
            break;
    }
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        _HUD.delegate = self;
        
    }
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.handleSuccess = NO;
    [[HHApprovalOpenClient sharedClient] handle:self.item.chkId result:self.handleResult.intValue contact:contact ccContacts:self.ccContactsWid comment:comment form:self.submitList sucess:^(id data) {
        self.HUD.labelText = @"提交成功";
        self.handleSuccess = YES;
        [self.HUD hide:YES afterDelay:1];
        
    } failure:^(NSInteger code) {
        self.HUD.labelText = @"提交失败";
        [self.HUD hide:YES afterDelay:1];
        
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (self.handleSuccess) {
        [self removeThisItemFromModel];
        [self backToList];
    }
}

- (void)removeThisItemFromModel
{
    HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:self.item.type];
    if (model) {
        [model removeItem:self.item];
    }
}


- (void)backToList{
    NSArray* controllers = self.navigationController.viewControllers;
    for (NSInteger index = controllers.count-1; index>=0; index--) {
        UIViewController* controller = [controllers objectAtIndex:index];
        if ([controller isKindOfClass:[HHApprovalController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:self.view.window];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

//—-before the View window disappear—-
-(void) viewWillDisappear:(BOOL)animated {
    //—-removes the notifications for keyboard—-
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    [super viewWillDisappear:animated];
}


//—-when the keyboard appears—-
-(void) keyboardWillShow:(NSNotification *) notification {
    
    if (!self.touchView) {
        _touchView = [[HHTouchView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        _touchView.hidden = YES;
        _touchView.delegate = self;
        [self.view addSubview:_touchView];
    }
    NSDictionary* info = [notification userInfo];
    //—-obtain the size of the keyboard—-
    NSValue *aValue =
    [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect =
    [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    //—-resize the scroll view (with keyboard)—-
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height -= (keyboardRect.size.height);
    self.touchView.frame = viewFrame;
    self.touchView.hidden = NO;
    
}

//—-when the keyboard disappears—-
-(void) keyboardWillHide:(NSNotification *) notification {
    //NSDictionary* info = [notification userInfo];
    if (self.touchView) {
        self.touchView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContactsView:nil];
    [self setCcContactsView:nil];
    [self setAddContactButton:nil];
    [self setCommentTextView:nil];
    [self setContactLabel:nil];
    [self setCcContactLabel:nil];
    [self setAddCCContactButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    if ([destination isKindOfClass:[HHWorkerChooseController class]]) {
        HHWorkerChooseController* chooseController = (HHWorkerChooseController*)destination;
        chooseController.cid = [HHAccount sharedAccount].currentCid;
        if (sender == self.addContactButton) {
            chooseController.allowsMultipleSelection = NO;
            chooseController.selectedWorkers = [[NSMutableArray alloc] initWithCapacity:1];
            if (self.contactWid && self.contactWid.integerValue > 0) {
                [chooseController.selectedWorkers addObject:[NSNumber numberWithInteger:self.contactWid.integerValue]];
            }
            chooseController.completionBlock = ^(NSArray* array){
                if (array.count == 1) {
                    NSNumber* wid = [array objectAtIndex:0];
                    self.contactWid = [NSNumber numberWithInteger:wid.integerValue];
                }
                else
                {
                    self.contactWid = nil;
                }
                [self.contactsBubbleView reloadData];
            };
			if (self.handleResult.integerValue == kApprovalHandleBack) {
				chooseController.candidatedWorkers = self.candidateWorkers;
			}
        }
        else if(sender == self.addCCContactButton)
        {
            chooseController.allowsMultipleSelection = YES;
            
            if (self.ccContactsWid && self.ccContactsWid.count > 0) {
                chooseController.selectedWorkers = [NSMutableArray arrayWithArray:self.ccContactsWid];
            }
            else
            {
                chooseController.selectedWorkers = [[NSMutableArray alloc] init];
            }
            chooseController.completionBlock = ^(NSArray* array){
                self.ccContactsWid = [NSMutableArray arrayWithArray:array];
                [self.ccContactsBubbleView reloadData];
            };
        }
    }
}

- (void)updateSubViewsFrame:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
    }
    if (!self.contactsView.hidden) {
        CGFloat bubbleViewMargin = kApprovalContactViewMinHeight - kApprovalContactBubbleViewMinHeight;
        CGFloat height = self.contactsBubbleView.contentSize.height + bubbleViewMargin;
        if (height > kApprovalContactViewMaxHeight) {
            height = kApprovalContactViewMaxHeight;
        }
        else if(height < kApprovalContactViewMinHeight)
        {
            height = kApprovalContactViewMinHeight;
        }
        CGRect frame = self.contactsBubbleView.frame;
        frame.size.height = height - bubbleViewMargin;
        self.contactsBubbleView.frame = frame;
        frame = self.contactsView.frame;
        frame.size.height = height;
        self.contactsView.frame = frame;
        
        CGFloat x = self.contactLabel.frame.origin.x;
        CGFloat width = self.addContactButton.frame.origin.x + self.addContactButton.frame.size.width - x;
        CGFloat y = self.contactsView.frame.size.height - 2.0f;
        self.contactsViewBottomLine1.frame = CGRectMake(x, y, width, 1.0f);
        self.contactsViewBottomLine2.frame = CGRectMake(x, y+1.0f, width, 1.0f);
    }
    if (!self.ccContactsView.hidden) {
        CGFloat y = 0.0f;
        if (!self.contactsView.hidden) {
            y = self.contactsView.frame.origin.y + self.contactsView.frame.size.height + 1;
        }
        
        CGFloat bubbleViewMargin = kApprovalContactViewMinHeight - kApprovalContactBubbleViewMinHeight;
        CGFloat height = self.ccContactsBubbleView.contentSize.height + bubbleViewMargin;
        if (height > kApprovalContactViewMaxHeight) {
            height = kApprovalContactViewMaxHeight;
        }
        else if(height < kApprovalContactViewMinHeight)
        {
            height = kApprovalContactViewMinHeight;
        }
        CGRect frame = self.ccContactsBubbleView.frame;
        frame.size.height = height - bubbleViewMargin;
        self.ccContactsBubbleView.frame = frame;
        frame = self.ccContactsView.frame;
        frame.origin.y = y;
        frame.size.height = height;
        self.ccContactsView.frame = frame;
        
        CGFloat x = self.ccContactLabel.frame.origin.x;
        CGFloat width = self.addCCContactButton.frame.origin.x + self.addCCContactButton.frame.size.width - x;
        y = self.ccContactsView.frame.size.height - 2.0f;
        self.ccContactsViewBottomLine1.frame = CGRectMake(x, y, width, 1.0f);
        self.ccContactsViewBottomLine2.frame = CGRectMake(x, y+1.0f, width, 1.0f);
    }
    CGFloat textViewY = 5.0f;
    if (!self.contactsView.hidden) {
        textViewY += self.contactsView.frame.size.height;
    }
    if (!self.ccContactsView.hidden) {
        textViewY += self.ccContactsView.frame.size.height;
    }
    CGRect frame = self.commentTextView.frame;
    frame.origin.y = textViewY;
    self.commentTextView.frame = frame;
    
    
    if (animated) {
        [UIView commitAnimations];
    }
}



#pragma mark - TouchIn view delegate
-(void)didTouchInView:(id)sender
{
	[self.commentTextView resignFirstResponder];
}


#pragma mark - bubble item menu


-(void)deleteSelectedCCContactBubble:(id)sender
{
    NSNumber* wid = [self.ccContactsWid objectAtIndex:self.ccContactsBubbleView.activeBubble.index];
    [self.ccContactsWid removeObject:wid];
    [self.ccContactsBubbleView removeItemAtIndex:self.ccContactsBubbleView.activeBubble.index animated:YES];
    
}

-(void)deleteSelectedContactBubble:(id)sender
{
    self.contactWid = nil;
    [self.contactsBubbleView removeItemAtIndex:self.contactsBubbleView.activeBubble.index animated:YES];
    
}


///////////////////////////////////////////////////////////////
#pragma mark - bubble view data source
///////////////////////////////////////////////////////////////

// DataSource

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView
{
    if (bubbleView == self.contactsBubbleView) {
        if (self.contactWid) {
            return 1;
        }
        else
        {
            return 0;
        }
        
    }
    else if (bubbleView == self.ccContactsBubbleView)
    {
        return self.ccContactsWid.count;
    }
    
    return 0;
}

-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleViewIN bubbleItemForIndex:(NSInteger)index
{
    // TODO: implement reuse queue
    
    NSString *itemIdentifier = @"bubble";
    
    HEBubbleViewItem *item = [bubbleViewIN dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    if (item == nil) {
        item = [[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    }
    HHCompany* company = [HHCompany findCompanyWithId:[HHAccount sharedAccount].currentCid];
    if (bubbleViewIN == self.contactsBubbleView) {
        NSNumber* wid = self.contactWid;
        HHWorker* worker = [company findWorker:wid];
        item.textLabel.text = worker.name;
    }
    else if (bubbleViewIN == self.ccContactsBubbleView)
    {
        NSNumber* wid = [self.ccContactsWid objectAtIndex:index];
        HHWorker* worker = [company findWorker:wid];
        item.textLabel.text = worker.name;
    }
    
    return item;
}

///////////////////////////////////////////////////////////////
#pragma mark - bubble view delegate
///////////////////////////////////////////////////////////////

// DataSource

// called when a bubble gets selected
-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"selected bubble at index");
}

// returns wheter to show a menu callout or not for a given index
-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"telling delegate to show menu");
    return YES;
}

/* ////////////////////////////////////////////////////////////////////////////////////////////////////
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !!!!! Always override canBecomeFirstResponder and return YES, otherwise the menu is not shown !!!!!!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 * //////////////////////////////////////////////////////////////////////////////////////////////////// */

-(BOOL)canBecomeFirstResponder
{
    NSLog(@"Asking %@ if it can become first responder",[self class]);
    return YES;
}


/*
 Create the menu items you want to show in the callout and return them. Provide selectors
 that are implemented in your bubbleview delegate. override canBecomeFirstResponder and return
 YES, otherwise menu will not be shown
 */

-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    NSArray *items;
    
    if (bubbleView == self.contactsBubbleView && !self.addContactButton.isHidden) {
        
        UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteSelectedContactBubble:)];
        items = [NSArray arrayWithObjects:item0, nil];
    }
    else if (bubbleView == self.ccContactsBubbleView)
    {
        UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteSelectedCCContactBubble:)];
        items = [NSArray arrayWithObjects:item0, nil];
    }
    
    return items;
}

-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"Did hide menu for bubble at index %li",(long)index);
}

-(void)bubbleView:(HEBubbleView *)bubbleView contentSizeDidChanged:(CGSize)contentSize{
    
    [self updateSubViewsFrame:YES];
}

@end
