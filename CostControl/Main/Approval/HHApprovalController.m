//
//  HHApprovalController.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalController.h"
#import "HHApprovalItemModel.h"
#import "HHUtils.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "SINavigationMenuView.h"
#import "HHAccount.h"
#import "HHCompany.h"
#import "REMenu.h"
#import "HHApprovalListCell.h"
#import "AppDelegate.h"

@interface HHApprovalController ()

@property (nonatomic, strong) NSDictionary* tableViewRefreshHeaderViews;
@property (nonatomic, strong) NSMutableDictionary* tableViewRefreshFooterViews;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) SINavigationMenuView* navMenuView;
@property (nonatomic, strong) UILabel* navTitleView;
@property (strong, nonatomic) REMenu *menu;

@end

@implementation HHApprovalController

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
    for (HHApprovalItemModel* model in [HHApprovalItemModel allModels].allValues) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelItemChanged:) name:HHApprovalModelItemChangedNotification object:model];
    }
	    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.backButton.frame =	CGRectMake(0, 7, 44.0, 30.0);
	[self.backButton setImage:[UIImage imageNamed:@"nav_sidebar_icon"] forState:UIControlStateNormal];
	[self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;
	
	// Do any additional setup after loading the view.
    _tableViews = [NSDictionary dictionaryWithObjectsAndKeys:self.waitTableView, kApprovalWaitIdentifier, self.overTableView, kApprovalOverIdentifier, self.mineTableView, kApprovalMineIdentifier, self.ccTableView, kApprovalCCIdentifier, nil];
    
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    
    [self initWithTitles:[NSArray arrayWithObjects:@"待办审批", @"已办事项", @"我的事项", @"抄送我的", nil] views:[NSArray arrayWithObjects:self.waitTableView, self.overTableView, self.mineTableView, self.ccTableView, nil] viewFrame:viewFrame];
    self.segmentedControl.backgroundImage = [UIImage imageNamed:@"bg_top_tab"];
    self.segmentedControl.backgroundDivImage = [UIImage imageNamed:@"div_top_tab"];
    self.segmentedControl.font = [UIFont systemFontOfSize:14.0f];
    self.segmentedControl.textColor = [UIColor darkTextColor];
    self.segmentedControl.selectedTextColor = [HHUtils hexStringToColor:@"#6cab36"];
    self.segmentedControl.selectionIndicatorColor = [HHUtils hexStringToColor:@"#6cab36"];
    self.segmentedControl.selectionIndicatorHeight = 3.0f;
    
    [self createHeaderViews];
    _tableViewRefreshFooterViews = [[NSMutableDictionary alloc] initWithCapacity:4];
    //[self createFooterViews];
    
    [self setCurrentViewIndex:0 animated:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCompanyChanged:) name:HHCurrentCompanyChangedNotification object:[HHAccount sharedAccount]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.revealSideViewController preloadViewController:[UIViewController new] forSide:PPRevealSideDirectionLeft withOffset:80];
    PPRevealSideInteractions inter = PPRevealSideInteractionNone;
    self.revealSideViewController.delegate = self;
    inter |= PPRevealSideInteractionNavigationBar;
    //inter |= PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenClosed = inter;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    return PPRevealSideDirectionLeft;
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {

}


- (void)backAction:(id)sender
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"确定要退出吗"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确定", nil];
	[alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
	[[HHAccount sharedAccount] signOut];
	[((AppDelegate*)[UIApplication sharedApplication].delegate).navCtr popToRootViewControllerAnimated:YES];
	}
}

- (void)modelItemChanged:(NSNotification *)info
{
    NSDictionary* dic = info.userInfo;
    NSString* modelIdentifier = [dic objectForKey:HHApprovalModelIdentifierKey];
    UITableView* tableView = [self.tableViews objectForKey:modelIdentifier];
    if (tableView) {
        [tableView reloadData];
    }
    if (tableView.contentSize.height >= tableView.frame.size.height) {
        if ([self.tableViewRefreshFooterViews objectForKey:modelIdentifier] == nil) {
            EGORefreshTableFooterView* footerView = [self createFooterView:modelIdentifier tableView:tableView];
            [self.tableViewRefreshFooterViews setObject:footerView forKey:modelIdentifier];
        }
        [self updateFooterView:tableView];
    }
    NSString* itemChangedType = [dic objectForKey:HHApprovalModelItemChangedTypeKey];
    if (itemChangedType) {
        if ([itemChangedType isEqualToString:HHApprovalModelItemUpdatedNotification]) {
            EGORefreshTableHeaderView* headerView = [self.tableViewRefreshHeaderViews objectForKey:modelIdentifier];
            if (headerView) {
                [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
            }
            NSLog(@"Approval model updated");
        }
        else if ([itemChangedType isEqualToString:HHApprovalModelItemLoadedMoreNotification])
        {
            EGORefreshTableFooterView* footerView = [self.tableViewRefreshFooterViews objectForKey:modelIdentifier];
            if (footerView) {
                [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
            }
            NSLog(@"Approval model loaded more");
        }
    }
}

- (void)handleCurrentViewChanged:(NSInteger)index
{
    [super handleCurrentViewChanged:index];
   
    UITableView* tableView = [self.views objectAtIndex:index];
    NSString* identifier = [self identifierOfTableView:tableView];
    HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:identifier];
    [tableView reloadData];
    if (model.isUpdating) {
        [self showRefreshHeader:tableView animated:YES];
    }
    else
    {
        [model updateIfNeed];
    }
    if (tableView.contentSize.height >= tableView.frame.size.height) {
        if ([self.tableViewRefreshFooterViews objectForKey:identifier] == nil) {
            EGORefreshTableFooterView* footerView = [self createFooterView:identifier tableView:tableView];
            [self.tableViewRefreshFooterViews setObject:footerView forKey:identifier];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITableView* tableView = [self.views objectAtIndex:self.currentViewIndex];
    if (tableView) {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        if (indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
	if (_navMenuView) {
        self.navigationItem.titleView = _navMenuView;
    }
    else
    {
        self.navTitleView.text = @"办公";
        if ([HHAccount sharedAccount].currentCid > 0) {
            HHCompany* company = [HHCompany findCompanyWithId:[HHAccount sharedAccount].currentCid];
            if (company) {
                NSString* fullName = company.fullname;
                NSString* shortName = company.shortname;
                if (shortName.length <= 0) {
                    shortName = fullName;
                    fullName = nil;
                }
                self.navTitleView.text = shortName;
            }
        }
        self.navigationItem.titleView = self.navTitleView;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([sender respondsToSelector:@selector(item)] && [destination respondsToSelector:@selector(setItem:)]) {
            [destination setValue:[sender valueForKey:@"item"] forKey:@"item"];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWaitTableView:nil];
    [self setOverTableView:nil];
    [self setMineTableView:nil];
    [self setCcTableView:nil];
    [super viewDidUnload];
}

- (HHApprovalItemModel*)modelOfTableView:(UITableView*)tableView
{
    return [HHApprovalItemModel modelWithIdentifier:[self identifierOfTableView:tableView]];
}

- (NSString*)identifierOfTableView:(UITableView*)tableView
{
    for (NSString* identifier in self.tableViews.allKeys) {
        if ([self.tableViews objectForKey:identifier] == tableView) {
            return identifier;
        }
    }
    return nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HHApprovalItemModel* model = [self modelOfTableView:tableView];
    return model.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    HHApprovalItemModel* model = [self modelOfTableView:tableView];
    CellIdentifier = [NSString stringWithFormat:@"ApprovalCell%@", model.identifier];
    HHApprovalListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
        if ([cell respondsToSelector:@selector(setItem:)]) {
            [cell setValue:[model.items objectAtIndex:indexPath.row] forKey:@"item"];
        }
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - HHApprovalItemModelDelegate
- (void)approvalItemModel:(HHApprovalItemModel*)model itemListUpdated:(NSInteger)itemCount
{
    if (itemCount > 0) {
        UITableView* tableView = [self.views objectAtIndex:self.currentViewIndex];
        if (tableView) {
            HHApprovalItemModel* tableModel = [self modelOfTableView:tableView];
            if (tableModel && tableModel == model) {
                [tableView reloadData];
            }
        }
    }
}

- (void)approvalItemModel:(HHApprovalItemModel*)model itemListMoreLoaded:(NSInteger)itemCount
{
    if (itemCount > 0) {
        UITableView* tableView = [self.views objectAtIndex:self.currentViewIndex];
        if (tableView) {
            HHApprovalItemModel* tableModel = [self modelOfTableView:tableView];
            if (tableModel && tableModel == model) {
                [tableView reloadData];
            }
        }
    }
}

#pragma mark
#pragma methods for creating and removing the header view

- (void)createHeaderViews
{
    if (self.tableViewRefreshHeaderViews == nil) {
        EGORefreshTableHeaderView* waitHeaderView = [self createHeaderView:kApprovalWaitIdentifier tableView:self.waitTableView];
        EGORefreshTableHeaderView* overHeaderView = [self createHeaderView:kApprovalOverIdentifier tableView:self.overTableView];
        EGORefreshTableHeaderView* mineHeaderView = [self createHeaderView:kApprovalMineIdentifier tableView:self.mineTableView];
        EGORefreshTableHeaderView* ccHeaderView = [self createHeaderView:kApprovalCCIdentifier tableView:self.ccTableView];
        _tableViewRefreshHeaderViews = [NSDictionary dictionaryWithObjectsAndKeys:waitHeaderView, kApprovalWaitIdentifier, overHeaderView, kApprovalOverIdentifier, mineHeaderView, kApprovalMineIdentifier, ccHeaderView, kApprovalCCIdentifier, nil];
        [waitHeaderView refreshLastUpdatedDate];
        [overHeaderView refreshLastUpdatedDate];
        [mineHeaderView refreshLastUpdatedDate];
        [ccHeaderView refreshLastUpdatedDate];
    }
    
    
}

- (EGORefreshTableHeaderView*)headerViewOfTableView:(UITableView*)tableView
{
    return [self.tableViewRefreshHeaderViews objectForKey:[self identifierOfTableView:tableView]];
}

-(EGORefreshTableHeaderView*)createHeaderView:(NSString*)identifier tableView:(UITableView*)tableView{
    EGORefreshTableHeaderView* headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                                             CGRectMake(0.0f, 0.0f - tableView.frame.size.height,
                                                        tableView.frame.size.width, tableView.frame.size.height)];
    headerView.delegate = self;
    [tableView addSubview:headerView];
    return headerView;
}

- (EGORefreshTableFooterView*)footerViewOfTableView:(UITableView*)tableView
{
    return [self.tableViewRefreshFooterViews objectForKey:[self identifierOfTableView:tableView]];
}

-(EGORefreshTableFooterView*)createFooterView:(NSString*)identifier tableView:(UITableView*)tableView{
    
    CGFloat height = MAX(tableView.contentSize.height, tableView.frame.size.height);
    EGORefreshTableFooterView* footerView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                             CGRectMake(0.0f, height,
                                                        tableView.frame.size.width, tableView.frame.size.height)];
    footerView.delegate = self;
    [tableView addSubview:footerView];
    return footerView;
}

-(void)updateFooterView:(UITableView*)tableView{
    EGORefreshTableFooterView *footerView = [self footerViewOfTableView:tableView];
    
    if (footerView) {
        CGFloat height = MAX(tableView.contentSize.height, tableView.frame.size.height);
        footerView.frame = CGRectMake(0.0f,
                                      height,
                                      tableView.frame.size.width,
                                      tableView.frame.size.height);
    }
    
}


#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(UITableView*)tableView animated:(BOOL)animated{
    EGORefreshTableHeaderView* headerView = [self headerViewOfTableView:tableView];
    if (headerView) {
        if (animated)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            // scroll the table view to the top region
            [tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
            [UIView commitAnimations];
        }
        else
        {
            tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        }
        [headerView setState:EGOOPullRefreshLoading];
    }
	
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
    UITableView* tableView = [self.views objectAtIndex:self.currentViewIndex];
    HHApprovalItemModel* model = [self modelOfTableView:tableView];
    if (aRefreshPos == EGORefreshHeader) {
        [model update];
    }
    else if (aRefreshPos == EGORefreshFooter)
    {
        [model loadMore];
    }

}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString* identifier = [self identifierOfTableView:(UITableView*)scrollView];
    if (identifier) {
        EGORefreshTableHeaderView* headerView = [self.tableViewRefreshHeaderViews objectForKey:identifier];
        if (headerView) {
            [headerView egoRefreshScrollViewDidScroll:scrollView];
        }
        EGORefreshTableFooterView* footerView = [self.tableViewRefreshFooterViews objectForKey:identifier];
        if (footerView) {
            [footerView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	NSString* identifier = [self identifierOfTableView:(UITableView*)scrollView];
    if (identifier) {
        EGORefreshTableHeaderView* headerView = [self.tableViewRefreshHeaderViews objectForKey:identifier];
        if (headerView) {
            [headerView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        EGORefreshTableFooterView* footerView = [self.tableViewRefreshFooterViews objectForKey:identifier];
        if (footerView) {
            [footerView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	for (NSString* identifier  in self.tableViews.allKeys) {
        EGORefreshTableHeaderView* headerView = [self.tableViewRefreshHeaderViews objectForKey:identifier];
        if (headerView == view) {
            HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:identifier];
            if (model) {
                return model.isUpdating;
            }
            return NO;
        }
        EGORefreshTableFooterView* footerView = [self.tableViewRefreshFooterViews objectForKey:identifier];
        if (footerView == view) {
            HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:identifier];
            if (model) {
                return model.isLoadingMore;
            }
            return NO;
        }
    }
	return NO; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    NSDate* date = nil;
	for (NSString* identifier  in self.tableViews.allKeys) {
        EGORefreshTableHeaderView* headerView = [self.tableViewRefreshHeaderViews objectForKey:identifier];
        if (headerView == view) {
            HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:identifier];
            date = model.lastUpdateTime;
            break;
        }
        EGORefreshTableFooterView* footerView = [self.tableViewRefreshFooterViews objectForKey:identifier];
        if (footerView == view) {
            HHApprovalItemModel* model = [HHApprovalItemModel modelWithIdentifier:identifier];
            date = model.lastUpdateTime;
            break;
        }
    }
    if (date) {
        return date;
    }
	return [NSDate date]; // should return date data source was last changed
	
}


- (void)didTapedOnMen
{
    if (_menu.isOpen) {
        [_menu close];
        [self.navMenuView setMenuButtonActive:NO];
    }
    else
    {
        NSMutableArray* menuItems = [[NSMutableArray alloc] initWithCapacity:[HHCompany companys].count];
        for (HHCompany* company in [HHCompany companys]) {
            NSString* fullName = company.fullname;
            NSString* shortName = company.shortname;
            if (shortName.length <= 0) {
                shortName = fullName;
                fullName = nil;
            }
            UIImage* companyIcon = [UIImage imageNamed:@"nav_done"];
            if (company.cid != [HHAccount sharedAccount].currentCid) {
                companyIcon = nil;
            }
            REMenuItem *menuItem = [[REMenuItem alloc] initWithTitle:shortName
                                                            subtitle:fullName
                                                               image:companyIcon
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  [self.navMenuView setMenuButtonActive:NO];
                                                                  if (item.tag > 0) {
                                                                      [HHAccount sharedAccount].currentCid = item.tag;
																  }
                                                              }];
            menuItem.tag = company.cid;
            [menuItems addObject:menuItem];
        }
        [self.navMenuView setMenuButtonActive:YES];
		
        _menu = [[REMenu alloc] initWithItems:menuItems];
        _menu.cornerRadius = 4;
        _menu.textColor = [HHUtils hexStringToColor:@"f7f7f7"];
        _menu.subtitleTextColor = [HHUtils hexStringToColor:@"f7f7f7"];
        _menu.backgroundColor = [HHUtils hexStringToColor:@"222222"];
        _menu.shadowColor = [UIColor blackColor];
        _menu.shadowOffset = CGSizeMake(0, 1);
        _menu.shadowOpacity = 1;
        _menu.imageOffset = CGSizeMake(5, -1);
        _menu.textAlignment = NSTextAlignmentLeft;
        _menu.subtitleTextAlignment = NSTextAlignmentLeft;
        _menu.textOffset = CGSizeMake(60.0f, 0);
        _menu.subtitleTextOffset = _menu.textOffset;
        
        [_menu showFromNavigationController:self.tabBarController.navigationController];
    }
}

- (void)currentCompanyChanged:(NSNotification *)info
{
    NSDictionary* dic = info.userInfo;
    NSNumber* cid = [dic objectForKey:HHCurrentCompanyKey];
    NSLog(@"Current company cid: %lld", cid.longLongValue);
    NSInteger companyCount = [HHCompany companys].count;
    HHCompany* company = [HHCompany companyWithId:cid];
    NSString* fullName = company.fullname;
    NSString* shortName = company.shortname;
    if (shortName.length <= 0) {
        shortName = fullName;
        fullName = nil;
    }
    if (companyCount > 1) {
        if (_navMenuView == nil) {
            CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
            _navMenuView = [[SINavigationMenuView alloc] initWithFrame:frame title:shortName];
            _navMenuView.delegate = self;
            self.tabBarController.navigationItem.titleView = _navMenuView;
        }
    }
    else
    {
        _navMenuView = nil;
    }
    if (_navMenuView) {
        _navMenuView.menuButton.title.text = shortName;
    }
    else
    {
        self.navTitleView.text = shortName;
    }
    
    //[self loadADs];
}

@end
