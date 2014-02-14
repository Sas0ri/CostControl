//
//  CCHeaderView4.m
//  CostControl
//
//  Created by Sasori on 14-1-24.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CCHeaderView4.h"

@implementation CCHeaderView4

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
			case 5:
			{
				CCGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:GeneralId];
				if (!cell) {
					cell = [self getGeneralCell];
				}
				cell.descriptionLabel.text = @"项目周期";
				cell.valueLabel.text = [NSString stringWithFormat:@"%@ 至 %@", self.modelDic[@"project_start_time"], self.modelDic[@"project_end_time"]];
				return cell;
			}
				break;
			case 6:
			{
				CCNoteCell* cell = [tableView dequeueReusableCellWithIdentifier:NoteId];
				if (!cell) {
					cell = [self getNoteCell];
				}
				cell.noteLabel.text = self.modelDic[@"project_remark"];
				return cell;
			}
				break;
			default:
				break;
		}
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 6) {
		NSString* note = self.modelDic[@""];
		CGFloat height = [note sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 9999)].height;
		height += 22;
		height = height > 44 ? : 44;
		return height;
	}
	return 44;
}

- (CGFloat)heightForModel:(NSDictionary *)modelDic
{
	NSString* note = modelDic[@""];
	CGFloat height = [note sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 9999)].height;
	height = height > 44 ? : 44;
	return [super heightForModel:modelDic] + 22 + height + 44;
}

- (CCNoteCell *)getNoteCell
{
	NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CCHeaderView" owner:nil options:nil];
	for (UITableViewCell* cell in arr) {
		if ([cell isKindOfClass:[CCNoteCell class]]) {
			return (CCNoteCell*)cell;
		}
	}
	return nil;
}

@end
