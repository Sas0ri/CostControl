//
//  ProjectCostAppCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ProjectCostCtr.h"
#import "CCHeaderView3.h"
#import "PCModel.h"
#import "CPDetailCell.h"
#import "HHUtils.h"

@interface ProjectCostCtr ()
@property (nonatomic, strong) PCModel* model;
@end

@implementation ProjectCostCtr

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_reloadData
{
	CCHeaderView3* headerView = [[CCHeaderView3 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
	CGRect r = headerView.frame;
	r.size.height = [headerView heightForModel:self.modelDic];
	headerView.frame = r;
	self.tableView.tableHeaderView = headerView;
	headerView.modelDic = self.modelDic;
	
	self.model = [[PCModel alloc] initWithDic:self.modelDic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return self.model.detailList.count + 4;
	return self.comments.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
	
	if (indexPath.row == 0) {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
		return cell;
	}
	if (indexPath.row > 0 && indexPath.row < self.model.detailList.count + 1) {
		DetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
		PCDetailModel* model = self.model.detailList[indexPath.row-1];
		cell.descriptionLabel.text = model.chargeName;
		cell.costLabel.text = [HHUtils regularStringFromDic:model.applyingAmount];
		cell.confirmField.text = [HHUtils regularStringFromDic:model.spAmount];
		cell.model = model;
		cell.delegate = self;
		return cell;
	}
	if (indexPath.row == self.model.detailList.count + 1) {
		CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CPDetailCell" forIndexPath:indexPath];
		cell.descritionLabel.text = @"合计（￥）";
		cell.detailLabel.text = [HHUtils regularStringFromDic:self.model.sum];
		return cell;
	}
	if (indexPath.row == self.model.detailList.count + 2) {
		CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CPDetailCell" forIndexPath:indexPath];
		cell.descritionLabel.text = @"预算比例";
		cell.detailLabel.text = self.model.percent;
		return cell;
	}
	if (indexPath.row == self.model.detailList.count + 3) {
		CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
		cell.descritionLabel.text = @"备注";
		cell.detailLabel.text = self.model.remark;
		
		CGRect r = CGRectMake(105, 12, 184, 21);
		CGFloat height  = [cell.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height+1;
		height = height > 21 ? height : 21;
		r.size.height = height;
		cell.detailLabel.frame = r;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return 44;
		}
		return [HHCommentCell cellHeight:self.comments[indexPath.row-1]];
	}
	if (indexPath.row > 0 && indexPath.row < self.model.detailList.count + 1) {
		return 80;
	}
	if (indexPath.row == self.model.detailList.count + 3) {
		NSString* text = self.modelDic[@"remark"];
		CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height + 22;
		height = height > 44 ? height: 44;
		return height;
	}
	return 44;
}

- (void)textDidConfirm:(NSString *)text cell:(UITableViewCell *)cell
{
//	NSIndexPath* index = [self.tableView indexPathForCell:cell];
//	PCDetailModel* model = self.model.detailList[index.row-1];
	PCDetailModel* model = ((DetailCell*)cell).model;
	model.spAmount = text;
	
	double sum = 0;
	for (PCDetailModel* detail in self.model.detailList) {
		sum += detail.spAmount.doubleValue;
	}
	sum += self.model.financeAmount;
	double result = sum/self.model.financeQuota*100;
	self.model.percent = [NSString stringWithFormat:@"%0.2f%%", result];
	NSIndexPath* path = [NSIndexPath indexPathForRow:self.model.detailList.count + 2 inSection:0];
	CPDetailCell* dc = (CPDetailCell*)[self.tableView cellForRowAtIndexPath:path];
	dc.detailLabel.text = self.model.percent;
}

- (NSArray *)submitArr
{
	NSMutableArray* arr = [NSMutableArray array];
	for (PCDetailModel* model in self.model.detailList) {
		NSDictionary* dic = @{@"id":model.pid, @"sp_amount": model.spAmount};
		[arr addObject:dic];
	}
	return arr;
}

@end
