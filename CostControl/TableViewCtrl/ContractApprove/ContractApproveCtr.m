//
//  ContractApproveCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "ContractApproveCtr.h"
#import "CADetailCell.h"
#import "CAPayCell.h"
#import "CPDetailCell.h"
#import "HHUtils.h"
#import "CCHeaderView3.h"

@interface ContractApproveCtr ()
@end

@implementation ContractApproveCtr

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
	NSArray* arr = self.modelDic[@"detail"];
    return arr.count + 8;
	}
	return self.comments.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
	
	if (indexPath.row < 8) {
		switch (indexPath.row) {
			case 0:
			{
				UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
				return cell;
			}
				break;
			case 1:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"合同名称";
				cell.detailLabel.text = self.modelDic[@"contract_name"];
				return cell;
			}
			case 2:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"合同编号";
				cell.detailLabel.text = self.modelDic[@"contract_no"];
				return cell;
			}
			case 3:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"合同总价款";
				cell.detailLabel.text = [HHUtils regularStringFromDic:self.modelDic[@"contract_amount"]];
				return cell;
			}
			case 4:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"对方单位";
				cell.detailLabel.text = self.modelDic[@"contract_name"];
				return cell;
			}
			case 5:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"合同周期";
				NSString* str = [NSString stringWithFormat:@"%@ 至 %@", self.modelDic[@"contract_start_time"], self.modelDic[@"contract_end_time"]];
				cell.detailLabel.text = str;
				return cell;
			}
			case 6:
			{
				CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
				cell.descritionLabel.text = @"合同摘要";
				cell.detailLabel.text = self.modelDic[@"contract_summary"];
				CGRect r = CGRectMake(105, 12, 192, 21);
				CGFloat height  = [cell.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(192, 999)].height+1;
				height = height > 21 ? height : 21;
				r.size.height = height;
				cell.detailLabel.frame = r;
				return cell;
			}
			case 7:
			{
				CADetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
				cell.descriptionLabel.text = @"付款方式";
				BOOL isMultiPay = [self.modelDic[@"is_multi_payment"] boolValue];
				cell.detailLabel.text = isMultiPay ? @"多次付款" : @"一次付款";
				return cell;
			}
			default:
				break;
		}
	} else {
		CAPayCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
		cell.model = self.modelDic[@"detail"][indexPath.row - 8];
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
	if (indexPath.row == 6) {
		NSString* text = self.modelDic[@"contract_summary"];
		CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(192, 999)].height + 22;
		height = height > 44 ? height: 44;
		return height;
	}
	return 44;
}

@end
