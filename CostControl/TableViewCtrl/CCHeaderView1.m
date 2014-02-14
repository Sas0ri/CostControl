//
//  CCHeaderView1.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CCHeaderView1.h"
#import "HHUtils.h"

@implementation CCHeaderView1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if (self = [super initWithFrame:frame style:style]) {
		self.delegate = self;
		self.dataSource = self;
	}
	return self;
}

- (void)setModelDic:(NSDictionary *)modelDic
{
	_modelDic = modelDic;
	[self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
		{
			CCTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:TypeId];
			if (!cell) {
				cell = [self getTypeCell];
			}
			cell.typeLabel.text = self.modelDic[@"fl_title"];
			return cell;
		}
			break;
		case 1:
		{
			CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:CompanyId];
			if (!cell) {
				cell = [self getGeneralCell];
			}
			cell.descriptionLabel.text = @"申请人";
			cell.valueLabel.text = self.modelDic[@"fl_wid_name"];
			return cell;
		}
			break;
		case 2:
		{
			CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:CompanyId];
			if (!cell) {
				cell = [self getGeneralCell];
			}
			NSString* dept = [HHUtils trimDepartment:self.modelDic[@"fl_wid_dept"]];
			cell.descriptionLabel.text = @"申请部门";
			cell.valueLabel.text = dept;
			return cell;
		}
			break;
		default:
			break;
	}
	return nil;
}

- (CCGeneralCell *)getGeneralCell
{
	NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CCHeaderView" owner:nil options:nil];
	for (UITableViewCell* cell in arr) {
		if ([cell isKindOfClass:[CCGeneralCell class]]) {
			return (CCGeneralCell*)cell;
		}
	}
	return nil;
}

- (CCTypeCell *)getTypeCell
{
	NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CCHeaderView" owner:nil options:nil];
	for (UITableViewCell* cell in arr) {
		if ([cell isKindOfClass:[CCTypeCell class]]) {
			return (CCTypeCell*)cell;
		}
	}
	return nil;
}

- (CGFloat)heightForModel:(NSDictionary *)modelDic
{
	return 132;
}

@end
