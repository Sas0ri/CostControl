//
//  CCHeaderView3.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CCHeaderView3.h"

@implementation CCHeaderView3

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
	return [super tableView:tableView numberOfRowsInSection:section] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (!cell) {
		switch (indexPath.row) {
			case 5:
			{
				CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:GeneralId];
				if (!cell) {
					cell = [self getGeneralCell];
				}
				cell.descriptionLabel.text = @"费用类别";
				NSString* str = [NSString stringWithFormat:@"%@-%@", self.modelDic[@"finance_upname"], self.modelDic[@"finance_name"]];
				cell.valueLabel.text = str;
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
	return [super heightForModel:modelDic] + 44;
}

@end
