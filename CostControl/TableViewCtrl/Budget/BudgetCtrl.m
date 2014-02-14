//
//  BudgetCtrl.m
//  CostControl
//
//  Created by Sasori on 14-1-16.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "BudgetCtrl.h"
#import "CCHeaderView4.h"
#import "SectionCell.h"
#import "BudgetModel.h"
#import "BudgetCell.h"
#import "SeparateCell.h"
#import "SumCell.h"
#import "HHUtils.h"

@interface BudgetCtrl ()
@property (nonatomic, strong) BudgetModel* model;

@end

@implementation BudgetCtrl

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
	CCHeaderView4* headerView = [[CCHeaderView4 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
	CGRect r = headerView.frame;
	r.size.height = [headerView heightForModel:self.modelDic];
	headerView.frame = r;
	self.tableView.tableHeaderView = headerView;
	headerView.modelDic = self.modelDic;
	
	self.model = [[BudgetModel alloc] initWithDic:self.modelDic[@"detail"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6 + self.model.outList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	}
	if (section == 1) {
		return self.model.inList.count+2;
	}
	if (section == 2) {
		return 1;
	}
	if (section > 2 && section < self.model.outList.count + 3) {
		BudgetOutModel* model = self.model.outList[section - 3];
		return model.detailList.count + 2;
	}
	if (section == self.model.outList.count + 3) {
		return 2;
	}
	if (section == self.model.outList.count + 4) {
		return self.comments.count+1;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
		return cell;
	}
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			SectionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell" forIndexPath:indexPath];
			cell.sectionLabel.text = @"收入";
			return cell;
		} else if (indexPath.row != self.model.inList.count + 1){
			BudgetCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCell" forIndexPath:indexPath];
			cell.delegate = self;
			cell.sum = self.model.inSum.doubleValue;
			cell.model = self.model.inList[indexPath.row - 1];
			return cell;
		} else {
			SumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SumCell" forIndexPath:indexPath];
			cell.number.text = [HHUtils regularStringFromDic:self.model.inSum];
			cell.title.text = @"收入合计";
			cell.percent.text = @"";
			return cell;
		}
	}
	if (indexPath.section == 2) {
			SectionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell" forIndexPath:indexPath];
			cell.sectionLabel.text = @"支出";
			return cell;
	}
	if (indexPath.section > 2 && indexPath.section < self.model.outList.count + 3) {
		BudgetOutModel* model = self.model.outList[indexPath.section - 3];
		if (indexPath.row == 0) {
			SeparateCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeparateCell" forIndexPath:indexPath];
			cell.summary.text = model.outDetail;
			return cell;
		} else if (indexPath.row != model.detailList.count + 1){
			BudgetCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCell" forIndexPath:indexPath];
			cell.delegate = self;
			BudgetDetailModel* detailModel = model.detailList[indexPath.row - 1];
			cell.sum = self.model.outSum.doubleValue;
			cell.model = detailModel;
			return cell;
		} else {
			SumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SumCell" forIndexPath:indexPath];
			cell.number.text = [HHUtils regularStringFromDic:model.outSum];
			cell.title.text = @"小计";
			if (self.model.outSum.doubleValue > 0.0) {
				cell.percent.text = [NSString stringWithFormat:@"%0.2f%%",model.outSum.doubleValue/self.model.outSum.doubleValue*100];
			} else {
				cell.percent.text = @"--";
			}
			return cell;
		}
	}
	if (indexPath.section == self.model.outList.count + 3) {
		if (indexPath.row == 0) {
			SumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SumCell" forIndexPath:indexPath];
			cell.number.text = [HHUtils regularStringFromDic:self.model.outSum];
			cell.title.text = @"支出成本合计";
			if (self.model.inSum.doubleValue > 0.0) {
				cell.percent.text = [NSString stringWithFormat:@"%0.2f%%", self.model.outSum.doubleValue/self.model.inSum.doubleValue*100];
			} else {
				cell.percent.text = @"--";
			}
			
			return cell;
		}
		if (indexPath.row == 1) {
			SumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SumCell" forIndexPath:indexPath];
			cell.number.text = [NSString stringWithFormat:@"%0.2f",self.model.inSum.doubleValue - self.model.outSum.doubleValue];
			cell.title.text = @"利润";
			if (self.model.inSum.doubleValue > 0.0) {
				cell.percent.text = [NSString stringWithFormat:@"%0.2f%%", (self.model.inSum.doubleValue - self.model.outSum.doubleValue)/self.model.inSum.doubleValue*100];
			} else {
				cell.percent.text = @"--";
			}
			
			return cell;

		}
	}
	if (indexPath.section == self.model.outList.count + 4) {
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
	if (indexPath.section == self.model.outList.count + 4) {
		if (indexPath.row == 0) {
			return 44;
		}
		return [HHCommentCell cellHeight:self.comments[indexPath.row-1]];
	}
	if (indexPath.row > 0) {
		NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
		if (indexPath.row != count - 1) {
			return 88;
		}
	}
	return 44;
}

- (void)budgetDidChange:(NSString *)budget cell:(UITableViewCell *)cell
{
	BudgetCell* bc = (BudgetCell*)cell;
	bc.model.realAmount = budget;
}

- (NSArray *)submitArr
{
	NSMutableArray* arr = [NSMutableArray array];
	for (BudgetDetailModel* model in self.model.inList) {
		NSDictionary* dic = @{@"id": model.bid,@"sy_real_quota":model.realAmount};
		[arr addObject:dic];
	}
	for (BudgetOutModel* model in self.model.outList) {
		for (BudgetDetailModel* dmodel in model.detailList) {
			NSDictionary* dic = @{@"id": dmodel.bid,@"sy_real_quota":dmodel.realAmount};
			[arr addObject:dic];
		}
	}
	return arr;
}

@end
