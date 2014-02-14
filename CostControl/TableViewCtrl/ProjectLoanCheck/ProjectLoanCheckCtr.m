//
//  ProjectLoanCheckCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ProjectLoanCheckCtr.h"
#import "CCHeaderView3.h"
#import "CPDetailCell.h"
#import "HHUtils.h"

@interface ProjectLoanCheckCtr ()

@end

@implementation ProjectLoanCheckCtr

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
	CCHeaderView3* headerView = [[CCHeaderView3 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
	CGRect r = headerView.frame;
	r.size.height = [headerView heightForModel:self.modelDic];
	headerView.frame = r;
	self.tableView.tableHeaderView = headerView;
	headerView.modelDic = self.modelDic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 5;
	return self.comments.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
			{
				UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
				return cell;
			}
				break;
			case 1:
			{
				CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descritionLabel.text = @"借款金额";
				cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"lend_amount"]];
				return cell;
			}
			case 2:
			{
				CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descritionLabel.text = @"报销金额";
				cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"reimburse_amount"]];
				return cell;
			}
			case 3:
			{
				CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descritionLabel.text = @"还款金额";
				cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"return_amount"]];
				return cell;
			}
			case 4:
			{
				CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
				cell.descritionLabel.text = @"备注";
				cell.detailLabel.text = self.modelDic[@"remark"];
				CGRect r = CGRectMake(105, 12, 184, 21);
				r.size.height = [cell.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height+1;
				cell.detailLabel.frame = r;
				return cell;
			}
			default:
				break;
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
	if (indexPath.row == 4 && indexPath.section == 0) {
		NSString* text = self.modelDic[@"remark"];
		CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height + 22;
		height = height > 44 ? height: 44;
		return height;
	}
	return 44;
}

@end
