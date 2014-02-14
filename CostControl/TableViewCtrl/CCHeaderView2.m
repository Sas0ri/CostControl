//
//  CCHeaderView2.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CCHeaderView2.h"

@implementation CCHeaderView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [super tableView:tableView numberOfRowsInSection:section] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (!cell) {
		switch (indexPath.row) {
			case 3:
			{
				CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:GeneralId];
				if (!cell) {
					cell = [self getGeneralCell];
				}
				cell.descriptionLabel.text = @"城市公司";
				cell.valueLabel.text = self.modelDic[@"citycorp_name"];
				return cell;
			}
				break;
			case 4:
			{
				CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:GeneralId];
				if (!cell) {
					cell = [self getGeneralCell];
				}
				cell.descriptionLabel.text = @"项目名称";
				cell.valueLabel.text = self.modelDic[@"project_name"];
				return cell;
			}
				break;
			default:
				break;
		}
	}
	return cell;
}

- (CGFloat)heightForModel:(NSDictionary *)modelDic
{
	return [super heightForModel:modelDic] + 88;
}

@end
