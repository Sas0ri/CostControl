//
//  BalanceCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-20.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "BalanceCtr.h"
#import "CCHeaderView1.h"
#import "BaDetailCell.h"
#import "CPDetailCell.h"

@interface BalanceCtr ()
@end

@implementation BalanceCtr

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
	CCHeaderView1* headerView = [[CCHeaderView1 alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
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
	if (section == 0) {
		NSArray* arr = self.modelDic[@"detail"];
		return arr.count + 2;
	}
	if (section == 1) {
		return self.comments.count + 1;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DescritionCell" forIndexPath:indexPath];
			return cell;
		}
		NSArray* arr = self.modelDic[@"detail"];
		if (indexPath.row > 0 && indexPath.row < arr.count + 1) {
			BaDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
			cell.model = arr[indexPath.row - 1];
			return cell;
		}
		if (indexPath.row == arr.count + 1) {
			CPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CPDetailCell" forIndexPath:indexPath];
			cell.descritionLabel.text = @"合计金额";
			cell.detailLabel.text = [self getSum];
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
	if (indexPath.section == 0) {
		NSArray* arr = self.modelDic[@"detail"];
		if (indexPath.row > 0 && indexPath.row < arr.count + 1) {
			return 160;
		}
		return 44;
	}
	return 44;
}

- (NSString*)getSum
{
	NSArray* arr = self.modelDic[@"detail"];
	double sum = 0;
	for (NSDictionary* dic in arr) {
		sum += [dic[@"agent_commission"] doubleValue];
	}
	return [NSString stringWithFormat:@"%0.2f", sum];
}

@end
