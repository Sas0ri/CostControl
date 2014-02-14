//
//  HHApprovalDetailController.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalDetailController.h"
#import "HHUtils.h"
#import "UIImageView+WebCache.h"
#import "HHApprovalItemModel.h"
#import "MBProgressHUD.h"
#import "HHApprovalOpenClient.h"
#import "HHAttach.h"
#import "HHAttachCell.h"
#import "HHCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "HHApprovalHandleController.h"

#import "BalanceCtr.h"
#import "ProjectCostCtr.h"
#import "ProjectDrawBackCtr.h"
#import "ProjectIncomingConfirmCtr.h"
#import "ProjectLoanCheckCtr.h"
#import "ProjectLoanCtr.h"
#import "ContractApproveCtr.h"
#import "ContractPaymentCtr.h"
#import "BudgetCell.h"
#import "CCBaseTableViewCtr.h"
#import "HHAccount.h"
#import "HHCompany.h"

#define kApprovalCommentKeyAuthor		@"username"
#define kApprovalCommentKeyDate			@"post_time"
#define kApprovalCommentKeyAvatarUrl    @"headpic"
#define kApprovalCommentKeyContent		@"comment"
#define kApprovalCommentKeyDept			@"dept_name"

@interface HHApprovalDetailController ()

@property (nonatomic) NSInteger currentViewIndex;
@property (nonatomic, strong) NSArray* contentViews;
@property (nonatomic, strong) MBProgressHUD* HUD;

@property (nonatomic, strong) NSNumber* nextPersonWid;
@property (nonatomic, strong) NSNumber* prevPersonWid;
@property (nonatomic, strong) NSNumber* handleResult;
@property (nonatomic, strong) NSArray* candidateWorkers;
@property (nonatomic) CGRect contentViewFrame;
@property (nonatomic, assign) BOOL isBackToSelf;

@property (nonatomic, strong) CCBaseTableViewCtr* contentTableViewCtr;

@end

@implementation HHApprovalDetailController

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
    self.view.clipsToBounds = YES;

	self.titleBackgroundImageView.image = [[UIImage imageNamed:@"bg_oa_detail_title"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
	
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    viewFrame.origin.y = viewFrame.size.height - self.toolbar.frame.size.height;
    viewFrame.size.height = self.toolbar.frame.size.height;
	if ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0) {
		viewFrame.origin.y -= 20;
	}
    self.toolbar.frame = viewFrame;
    
    viewFrame = self.view.bounds;
    viewFrame.origin.y = self.titleBackgroundImageView.frame.origin.y + self.titleBackgroundImageView.frame.size.height;
    viewFrame.size.height = self.toolbar.frame.origin.y - viewFrame.origin.y;
    self.contentViewFrame = viewFrame;
    
    viewFrame.origin.x += 320;
    self.contentView.frame = viewFrame;
    self.commentTableView.frame = viewFrame;
    self.attachsTableView.frame = viewFrame;

    self.currentViewIndex = -1;
    
	NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
	[self.toolbar setBackgroundImage:[[UIImage imageNamed:@"chat_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	[self.toolbar setClipsToBounds:YES];
	
	CustomSegmentedControl* csc = [[CustomSegmentedControl alloc] initWithSegmentCount:2 segmentsize:CGSizeMake(44, 30) dividerImage:nil tag:0 delegate:self];
	csc.backgroundColor = [UIColor clearColor];
	CGRect r = csc.frame;
	r.origin.x = 6;
	r.origin.y = 8;
	csc.frame = r;
	self.viewsSegmentedControl = csc;
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:csc];
	[items addObject:item];
	
	UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:item1];
    
	
    _contentViews = [NSArray arrayWithObjects:self.contentView, self.attachsTableView, nil];
    [self setCurrentView:0 animated:NO];
    
    [self updateDetailTitleFrame];
    
    if ([self.item.type isEqualToString:kApprovalWaitIdentifier] || self.item.status.intValue == 0) {
		UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(260, 8, 54, 30);
		[btn addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
		NSString* title = @"处理";
		if (self.isBackToSelf) {
			title = @"回复";
			self.handleResult = @(kApprovalHandleReply);
		}
		[btn setTitle:title forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithHexString:@"6cab36"] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont systemFontOfSize:12];
		btn.clipsToBounds = YES;
		UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
		[items addObject:item2];
    }
    [self.toolbar setItems:items];
    [self loadDetail];

    self.authorAvatarImageView.layer.masksToBounds = YES;
    self.authorAvatarImageView.layer.cornerRadius = self.authorAvatarImageView.bounds.size.width/2;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([sender respondsToSelector:@selector(attach)] && [destination respondsToSelector:@selector(setAttach:)]) {
            [destination setValue:[sender valueForKey:@"attach"] forKey:@"attach"];
        }
    }
    if ([destination respondsToSelector:@selector(setHandleResult:)]) {
        [destination setValue:self.handleResult forKey:@"handleResult"];
    }
    if ([destination respondsToSelector:@selector(setItem:)]) {
        [destination setValue:self.item forKey:@"item"];
    }
    if ([destination respondsToSelector:@selector(setContactWid:)]) {
        switch (self.handleResult.integerValue) {
            case kApprovalHandleBack:
                [destination setValue:self.prevPersonWid forKey:@"contactWid"];
                break;
            case kApprovalHandleAgreeNextPerson:
                [destination setValue:self.nextPersonWid forKey:@"contactWid"];
                break;
            case kApprovalHandleAgreeLastPerson:
                [destination setValue:nil forKey:@"contactWid"];
                break;
            case kApprovalHandleDisagree:
                [destination setValue:nil forKey:@"contactWid"];
                break;
			case kApprovalHandleReply:
				[destination setValue:self.candidateWorkers[self.candidateWorkers.count - 1] forKey:@"contactWid"];
                break;
            default:
                break;
        }
    }
	if ([destination respondsToSelector:@selector(setSubmitList:)]) {
		[destination performSelector:@selector(setSubmitList:) withObject:self.contentTableViewCtr.submitArr];
	}
	if ([destination respondsToSelector:@selector(setCandidateWorkers:)]) {
		[destination performSelector:@selector(setCandidateWorkers:) withObject:self.candidateWorkers];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath* indexPath = [self.commentTableView indexPathForSelectedRow];
    if (indexPath) {
        [self.commentTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    indexPath = [self.attachsTableView indexPathForSelectedRow];
    if (indexPath) {
        [self.attachsTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)viewDidUnload {
    [self setAuthorAvatarImageView:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [self setAuthorLabel:nil];
    [self setContentView:nil];
    [self setCommentTableView:nil];
    [self setTitleBackgroundImageView:nil];
    [self setToolbar:nil];
    [self setAttachsTableView:nil];
    [self setViewsSegmentedControl:nil];
    [super viewDidUnload];
}

- (IBAction)handle:(id)sender
{
	for (NSDictionary* dic in self.contentTableViewCtr.submitArr) {
		for (NSObject* value in dic.allValues) {
			if ([value isKindOfClass:[NSString class]] && ((NSString*)value).length == 0) {
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"抱歉"
																message:@"输入金额不能为空"
															   delegate:nil
													  cancelButtonTitle:@"确定"
													  otherButtonTitles:nil, nil];
				[alert show];
				return;
			}
		}
	}
    UIActionSheet* sheet = nil;
    if (self.nextPersonWid) {
        if (self.prevPersonWid) {
            sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"同意并提交" otherButtonTitles:@"不同意", @"回退", nil];
        }
        else
        {
            sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"同意并提交" otherButtonTitles:@"不同意", nil];
        }
        
    }
    else
    {
        if (self.prevPersonWid) {
            sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"同意并结束" otherButtonTitles:@"同意并提交", @"不同意", @"回退", nil];
        }
        else
        {
			if (self.isBackToSelf) {
				sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", nil];
			} else {
				if ([HHAccount sharedAccount].isCeo) {
					sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"同意并结束" otherButtonTitles:@"同意并提交", @"不同意",@"回退", nil];
				} else {
					sheet = [[UIActionSheet alloc] initWithTitle:@"处理审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意并提交", @"不同意",@"回退", nil];
				}
			}
        }
        
    }
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld", (long)buttonIndex);
    self.handleResult = nil;
    if (self.nextPersonWid) {
        if (self.prevPersonWid) {
            switch (buttonIndex) {
                case 0:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeNextPerson];
                    break;
                case 1:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleDisagree];
                    break;
                case 2:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleBack];
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (buttonIndex) {
                case 0:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeNextPerson];
                    break;
                case 1:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleDisagree];
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        if (self.prevPersonWid) {
            switch (buttonIndex) {
                case 0:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeLastPerson];
                    break;
                case 1:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeNextPerson];
                    break;
                case 2:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleDisagree];
                    break;
                case 3:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleBack];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
			if (self.isBackToSelf) {
				if (buttonIndex == 0) {
					self.handleResult = @(kApprovalHandleReply);
				}
			} else {
			if (![HHAccount sharedAccount].isCeo) {
				buttonIndex++;
			}
            switch (buttonIndex) {
                case 0:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeLastPerson];
                    break;
                case 1:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleAgreeNextPerson];
                    break;
                case 2:
                    self.handleResult = [NSNumber numberWithInteger:kApprovalHandleDisagree];
                    break;
				case 3:
					self.handleResult = [NSNumber numberWithInteger:kApprovalHandleBack];
					break;
                default:
                    break;
            }
			}
        }
    }
    if (self.handleResult) {
        [self performSegueWithIdentifier:@"HandleApproval" sender:self];
    }
}

#pragma mark - SetCurrentView

- (IBAction)handleCurrentViewChanged:(UISegmentedControl *)sender
{
    [self setCurrentView:sender.selectedSegmentIndex animated:YES];
}


- (void)setCurrentView:(NSInteger)index animated:(BOOL)animated
{
    if (self.currentViewIndex == index || index >= self.contentViews.count) {
        return;
    }
    
    UITableView* tableView = [self.contentViews objectAtIndex:index];
    if ([tableView isKindOfClass:[UITableView class]]) {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        if (indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    
    if (!animated) {
        UIView* view = [self.contentViews objectAtIndex:index];
        view.frame = self.contentViewFrame;
    }
    else
    {
        if (self.currentViewIndex < 0 || self.currentViewIndex >= self.contentViews.count) {
            NSLog(@"fHHApprovalDetailController currentViewIndex invalid");
            return;
        }
        UIView* currentView = [self.contentViews objectAtIndex:self.currentViewIndex];
        UIView* nextView = [self.contentViews objectAtIndex:index];
        CGRect viewFrame = currentView.frame;
        CGRect nextFrame = viewFrame;
        if (index > self.currentViewIndex) {
            nextFrame.origin.x += nextFrame.size.width;
        }
        else
        {
            nextFrame.origin.x -= nextFrame.size.width;
        }
        nextView.frame = nextFrame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        nextView.frame = viewFrame;
        if (index > self.currentViewIndex) {
            viewFrame.origin.x -= viewFrame.size.width;
        }
        else
        {
            viewFrame.origin.x += viewFrame.size.width;
        }
        currentView.frame = viewFrame;
        
        [UIView commitAnimations];
        
    }
    self.currentViewIndex = index;
    if (self.commentTableView == [self.contentViews objectAtIndex:self.currentViewIndex]) {
        [self loadComment];
    }
}

#pragma mark - Update Detail Title Frame

- (void)updateDetailTitleFrame
{
    [self.authorAvatarImageView setImageWithURL:self.item.avatarUrl placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    self.titleLabel.text = self.item.summary;
    if ([self.item.type isEqualToString:kApprovalMineIdentifier]) {
        if (self.item.status.integerValue == 2) {
            self.authorLabel.text = @"不同意";
            self.authorLabel.textColor = [UIColor redColor];
        }
        else if (self.item.status.integerValue == 3)
        {
            self.authorLabel.text = @"同意";
            self.authorLabel.textColor = [HHUtils hexStringToColor:@"#14a5a2"];
        }
		else if (self.item.status.integerValue == 1)
        {
            self.authorLabel.text = @"审批中";
            self.authorLabel.textColor = [HHUtils hexStringToColor:@"#07a8fc"];
        } else if (self.item.status.integerValue == 0) {
			self.authorLabel.text = @"回退";
            self.authorLabel.textColor = [HHUtils hexStringToColor:@"#07a8fc"];
		}    }
    else
    {
		NSString* dept = [self.item.deptName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        self.authorLabel.text = [NSString stringWithFormat:@"[%@] %@", dept, self.item.workerName];
    }
	self.timeLabel.text = [HHUtils standardDateTimeString:self.item.updateTime];
    
	CGRect frame = self.titleLabel.frame;
	CGFloat height = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(236, 9999) lineBreakMode:NSLineBreakByCharWrapping].height+2;
	frame.size.height = height;
    self.titleLabel.frame = frame;
	
	frame = self.titleBackgroundImageView.frame;
	frame.size.height = height + 61;
	self.titleBackgroundImageView.frame = frame;
	
	frame = self.timeLabel.frame;
	frame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + 5;
	self.timeLabel.frame = frame;
	
	frame = self.authorLabel.frame;
	frame.origin.y = CGRectGetMaxY(self.timeLabel.frame) + 4;
	self.authorLabel.frame = frame;
	
	frame = self.attachsTableView.frame;
	frame.origin.y = CGRectGetMaxY(self.titleBackgroundImageView.frame);
	frame.size.height = self.toolbar.frame.origin.y - frame.origin.y;
	self.attachsTableView.frame = frame;
	
	frame = self.contentView.frame;
	frame.origin.y = CGRectGetMaxY(self.titleBackgroundImageView.frame);
	frame.size.height = self.toolbar.frame.origin.y - frame.origin.y;
	self.contentView.frame = frame;}

#pragma mark - Load detail

- (void)loadDetail
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
    }
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    [[HHApprovalOpenClient sharedClient] loadDetail:self.item sucess:^(id data){
        self.detailData = data;
        self.HUD.hidden = YES;
        self.candidateWorkers = [self getCandidateWorkerFromDic:data];
		NSDictionary* modelDic = data;
        if (modelDic) {
			CCBaseTableViewCtr* vc = [self chooseControllerWithType:self.item.sqName];
			vc.view.frame = self.contentView.bounds;
			[self.contentView addSubview:vc.view];
			[self addChildViewController:vc];
			[vc didMoveToParentViewController:self];
			if ([vc respondsToSelector:@selector(setModelDic:)]) {
				[vc performSelector:@selector(setModelDic:) withObject:modelDic];
			}
			self.contentTableViewCtr = vc;
        }
        NSArray* attachExts = [self.detailData objectForKey:@"attach"];
        if (attachExts && [attachExts isKindOfClass:[NSArray class]] && attachExts.count > 0) {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in attachExts) {
                NSString* name = [dic objectForKey:@"fa_showname"];
                NSString* url = [dic objectForKey:@"fa_url"];
                NSString* type = [dic objectForKey:@"fa_showtype"];
                if (name.length > 0 && url.length > 0 && type.length > 0) {
                    HHAttach* attach = [[HHAttach alloc] init];
                    attach.fileName = name;
                    attach.url = url;
                    attach.fileType = type;
                    [array addObject:attach];
                }
            }
            if (array.count > 0) {
                self.attachs = array;
				[self.viewsSegmentedControl reloadData];
                [self.attachsTableView reloadData];
            }
        }
        NSDictionary* prevPersonDic = [self.detailData objectForKey:@"prev"];
        if (prevPersonDic && [prevPersonDic isKindOfClass:[NSDictionary class]]) {
            NSNumber* code = [HHUtils numberIdFromJsonId:[prevPersonDic objectForKey:@"code"]];
            if (code && code.integerValue == 0) {
                id ext = [prevPersonDic objectForKey:@"ext"];
                if (ext && [ext isKindOfClass:[NSNumber class]]) {
                    self.prevPersonWid = nil;
                }
                else if (ext && [ext isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* widDic = ext;
                    self.prevPersonWid = [HHUtils numberIdFromJsonId:[widDic objectForKey:@"wid"]];
                    if (self.prevPersonWid.integerValue == 0) {
                        self.prevPersonWid = nil;
                    }
                }
            }
        }
        
        NSDictionary* nextPersonDic = [self.detailData objectForKey:@"next"];
        if (nextPersonDic && [nextPersonDic isKindOfClass:[NSDictionary class]]) {
            NSNumber* code = [HHUtils numberIdFromJsonId:[nextPersonDic objectForKey:@"code"]];
            if (code && code.integerValue == 0) {
                id ext = [nextPersonDic objectForKey:@"ext"];
                if (ext && [ext isKindOfClass:[NSNumber class]]) {
                    self.nextPersonWid = nil;
                }
                else if (ext && [ext isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* widDic = ext;
                    self.nextPersonWid = [HHUtils numberIdFromJsonId:[widDic objectForKey:@"wid"]];
                    if (self.nextPersonWid.integerValue == 0) {
                        self.nextPersonWid = nil;
                    }
                }
            }
        }
        
        
    } failure:^(NSInteger code) {
        self.HUD.hidden = YES;
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"数据加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (NSArray*)getCandidateWorkerFromDic:(NSDictionary*)dic
{
	NSMutableArray* result = [NSMutableArray array];
	HHCompany* company = [HHCompany getCompanyWithId:[HHAccount sharedAccount].currentCid];
	HHWorker* selfWorker = [company workerWithUid:[HHAccount sharedAccount].uid];
	if ([self.item.type isEqualToString:kApprovalMineIdentifier]) {
		self.isBackToSelf = self.item.status.intValue == 0;
	} else if ([self.item.type isEqualToString:kApprovalWaitIdentifier]) {
	NSArray* dicArray = dic[@"formsdone_line"];
	BOOL isBackToSelf = NO;
	for (NSDictionary* info in dicArray) {
		NSNumber* wid = @([info[@"fd_wid"] longLongValue]);
		[result addObject:wid];
		if ([wid isEqualToNumber:selfWorker.wid]) {
			if ([info[@"fd_tag"] isKindOfClass:[NSString class]]) {
				NSString* tag = info[@"fd_tag"];
				if ([tag isEqualToString:@"back"]) {
					isBackToSelf = YES;
				}
			}
		}
	}
	self.isBackToSelf = isBackToSelf;
	

	if (isBackToSelf) {
		result = [@[[result lastObject]] mutableCopy];
		return result;
	}
	}

	NSString* name = dic[@"fl_wid_name"];
	NSString* dept = [HHUtils trimDepartment:dic[@"fl_wid_dept"]];
	HHWorker* worker = [[HHCompany getCompanyWithId:[HHAccount sharedAccount].currentCid] findWorkerWithName:name dept:dept];
	if (worker) {
		[result addObject:worker.wid];
	}
	return result;
}

- (CCBaseTableViewCtr*)chooseControllerWithType:(NSString*)type
{
	CCBaseTableViewCtr* ret = nil;
	NSString* storyBoardId = @"";
	if ([type hasPrefix:@"项目收益预测表"]) {
		storyBoardId = @"Budget";
	}
	if ([type hasPrefix:@"项目收入确认单"]) {
		storyBoardId = @"ProjectIncoming";
	}
	if ([type hasPrefix:@"项目退款申请单"]) {
		storyBoardId = @"ProjectDrawBack";
	}
	if ([type hasPrefix:@"项目费用申请单"] || [type hasPrefix:@"项目费用报销单"] || [type hasPrefix:@"项目费用请款单"]) {
		storyBoardId = @"ProjectCost";
	}
	if ([type hasPrefix:@"合同审批单"]) {
		storyBoardId = @"ContractApprove";
	}
	if ([type hasPrefix:@"合同付款单"]) {
		storyBoardId = @"ContractPayment";
	}
	if ([type hasPrefix:@"项目借款单"]) {
		storyBoardId = @"ProjectLoan";
	}
	if ([type hasPrefix:@"项目借款核销单"]) {
		storyBoardId = @"ProjectLoanCheck";
	}
	if ([type hasPrefix:@"中介佣金结算表"]) {
		storyBoardId = @"Balance";
	}

	ret = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyBoardId];
	return ret;
}

#pragma mark - Load comment

- (void)loadComment
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
    }
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    [[HHApprovalOpenClient sharedClient] loadComment:self.item sucess:^(id data){
        NSArray* arr = data;
        self.HUD.hidden = YES;
        self.comments = nil;
        
        if (arr && [arr isKindOfClass:[NSArray class]] && arr.count > 0) {
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:arr.count];
            for (NSDictionary* dic in arr) {
                HHComment* comment = [[HHComment alloc] init];
                comment.dept = [dic objectForKey:kApprovalCommentKeyDept];
                comment.workerName = [dic objectForKey:kApprovalCommentKeyAuthor];
                if ([dic objectForKey:kApprovalCommentKeyDept] && [[dic objectForKey:kApprovalCommentKeyDept] isKindOfClass:[NSString class]]) {
                    comment.dept = [dic objectForKey:kApprovalCommentKeyDept];
                }
                else
                {
                    comment.dept = @"部门";
                }
                
                if ([dic objectForKey:kApprovalCommentKeyAvatarUrl] && [[dic objectForKey:kApprovalCommentKeyAvatarUrl] isKindOfClass:[NSString class]]) {
                    comment.avatarUrl = [NSURL URLWithString:[dic objectForKey:kApprovalCommentKeyAvatarUrl]];
                }
                else
                {
                    comment.avatarUrl = nil;
                }
//                comment.time = [HHUtils dateFromString:[dic objectForKey:kApprovalCommentKeyDate]];
				comment.time = dic[kApprovalCommentKeyDate];
                comment.content = [dic objectForKey:kApprovalCommentKeyContent];
                [array addObject:comment];
            }
            if (array.count > 0) {
                self.comments = array;
            }
        }
        else
        {
            self.comments = nil;
        }
		NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
		self.comments = [self.comments sortedArrayUsingDescriptors:@[sd]];
        [self.commentTableView reloadData];
		
    } failure:^(NSInteger code) {
        self.HUD.hidden = YES;
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"数据加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.commentTableView) {
        return self.comments.count;
    }
    else if (tableView == self.attachsTableView)
    {
        return self.attachs.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    if (tableView == self.commentTableView) {
        CellIdentifier = @"CommentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell && [cell respondsToSelector:@selector(setComment:)]) {
            [cell setValue:[self.comments objectAtIndex:indexPath.row] forKey:@"comment"];
        }
        
    }
    else if (tableView == self.attachsTableView)
    {
        CellIdentifier = @"AttachCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell && [cell respondsToSelector:@selector(setAttach:)]) {
            [cell setValue:[self.attachs objectAtIndex:indexPath.row] forKey:@"attach"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.commentTableView) {
        HHComment* comment = [self.comments objectAtIndex:indexPath.row];
        return [HHCommentCell cellHeight:comment];
    }
    else if (tableView == self.attachsTableView)
    {
        return 52.0f;
    }
    return 44.0f;
}

- (UIButton *)buttonFor:(CustomSegmentedControl *)segmentedControl atIndex:(NSUInteger)segmentIndex
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	switch (segmentIndex) {
		case 0:
			[button setTitle:@"详情" forState:UIControlStateNormal];
			button.selected = YES;
			break;
		case 1:
			[button setTitle:[NSString stringWithFormat:@"附件(%ld)", (unsigned long)self.attachs.count] forState:UIControlStateNormal];
			break;
		case 2:
			[button setTitle:@"意见" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
	
	button.frame = CGRectMake(0, 0, 44, 30);
	[button setBackgroundImage:[[UIImage imageNamed:@"seg_normal"] stretchableImageWithLeftCapWidth:button.frame.size.width/2-2 topCapHeight:0] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"seg_selected"] stretchableImageWithLeftCapWidth:button.frame.size.width/2-2 topCapHeight:0] forState:UIControlStateSelected];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[button setTitleColor:[UIColor colorWithHexString:@"6cab36"] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:12];
	
	return button;
}

- (void)touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
	[self setCurrentView:segmentIndex animated:YES];
}

@end
