//
//  ProjectIncomingConfirmCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-19.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ProjectIncomingConfirmCtr.h"
#import "CCHeaderView2.h"
#import "CPDetailCell.h"

@interface ProjectIncomingConfirmCtr ()
@property (nonatomic, assign) NSUInteger listCount;
@property (nonatomic, strong) NSArray* modelList;
@end

@implementation ProjectIncomingConfirmCtr

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_reloadData
{
	CCHeaderView2* headerView = [[CCHeaderView2 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
	CGRect r = headerView.frame;
	r.size.height = [headerView heightForModel:self.modelDic];
	headerView.frame = r;
	self.tableView.tableHeaderView = headerView;
	headerView.modelDic = self.modelDic;
	
	NSArray* array = self.modelDic[@"detail"];
	NSMutableArray* modelList = [NSMutableArray array];
	for (NSDictionary* dic in array) {
		PICModel* model = [[PICModel alloc] initWithDic:dic];
		[modelList addObject:model];
	}
	self.listCount = array.count;
	self.modelList = modelList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return self.listCount+2;
	return self.comments.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return 44;
		}
		return [HHCommentCell cellHeight:self.comments[indexPath.row-1]];
	}
	if (indexPath.row > 0 && indexPath.row < self.listCount+1 && indexPath.section == 0) {
		return 230;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
	
	if (indexPath.row > 0 && indexPath.row < self.listCount+1) {
		static NSString *CellIdentifier = @"ConfirmCell";
		ConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		cell.model = self.modelList[indexPath.row - 1];
		cell.delegate = self;
		
		return cell;
	} else if (indexPath.row == 0){
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
		return cell;
	} else {
		CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
		cell.descritionLabel.text = @"合计金额";
		cell.detailLabel.text = [NSString stringWithFormat:@"%0.2f", [self getSum]];
		return cell;
	}
	}
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentSectionCell" forIndexPath:indexPath];
			return cell;
		}
		HHCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
		cell.comment = self.comments[indexPath.row-1];
		return cell;
	}
	return nil;
}

- (double)getSum
{
	double sum = 0;
	NSArray* list = self.modelList;
	for (PICModel* model in list) {
		sum += [model.confirmed doubleValue];
	}
	return sum;
}

- (void)textDidConfirm:(NSString *)text cell:(UITableViewCell *)cell
{
//	NSIndexPath* index = [self.tableView indexPathForCell:cell];
//	PICModel* model = self.modelList[index.row-1];
	PICModel* model = ((ConfirmCell*)cell).model;
	model.confirmed = text;
}

- (NSArray *)submitArr
{
	NSMutableArray* arr = [NSMutableArray array];
	for (PICModel* model in self.modelList) {
		NSDictionary* dic = @{@"id": model.pid, @"cwhd_amount":model.confirmed};
		[arr addObject:dic];
	}
	return arr;
}

@end


