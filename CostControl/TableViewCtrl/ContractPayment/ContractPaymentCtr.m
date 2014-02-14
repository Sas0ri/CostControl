//
//  ContractPaymentCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ContractPaymentCtr.h"
#import "CPDetailCell.h"
#import "CCHeaderView3.h"
#import "HHUtils.h"

@interface ContractPaymentCtr ()
@end

@implementation ContractPaymentCtr

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

- (void)_reloadData
{
	CCHeaderView3* headerView = [[CCHeaderView3 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
	CGRect r = headerView.frame;
	r.size.height = [headerView heightForModel:self.modelDic];
	headerView.frame = r;
	self.tableView.tableHeaderView = headerView;
	headerView.modelDic = self.modelDic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 11;
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
//		case 1:
//		{
//			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
//			cell.descritionLabel.text = @"合同名称";
//			cell.detailLabel.text = self.modelDic[@"contract_name"];
//			return cell;
//		}
//			break;
		case 1:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合同编号";
			cell.detailLabel.text = self.modelDic[@"contract_no"];
			return cell;
		}
			break;
		case 2:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合同总价款";
			cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"contract_amount"]];
			return cell;
		}
			break;
		case 3:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"收款单位";
			cell.detailLabel.text = self.modelDic[@"payee_name"];
			return cell;
		}
			break;
		case 4:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合同周期";
			NSString* str = [NSString stringWithFormat:@"%@ 至 %@", self.modelDic[@"contract_start_time"],self.modelDic[@"contract_end_time"]];
			cell.detailLabel.text = str;
			return cell;
		}
			break;
		case 5:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合同发生额";
			cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"contract_actual_amount"]];
			return cell;
		}
			break;
		case 6:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"本次应付款";
			cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"payable_amount"]];
			return cell;
		}
			break;
		case 7:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"开户银行";
			cell.detailLabel.text = self.modelDic[@"bank_name"];
			return cell;
		}
			break;
		case 8:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"银行帐号";
			cell.detailLabel.text = self.modelDic[@"bank_account"];
			return cell;
		}
			break;
		case 9:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合同状态";
			NSString* str = [self.modelDic[@"is_payoff"] intValue] == 0 ? @"未结清" : @"已结清";
			cell.detailLabel.text = str;
			return cell;
		}
			break;
		case 10:
		{
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"备注";
			cell.detailLabel.text = self.modelDic[@"remark"];
			CGRect r = CGRectMake(105, 12, 184, 21);
			CGFloat height  = [cell.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height+1;
			height = height > 21 ? height : 21;
			r.size.height = height;
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
	if (indexPath.row == 10) {
		NSString* text = self.modelDic[@"remark"];
		CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(184, 999)].height + 22;
		height = height > 44 ? height: 44;
		return height;
	}
	return 44;
}

@end
