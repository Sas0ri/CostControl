//
//  CCBaseTableViewCtr.m
//  CostControl
//
//  Created by Sasori on 14-1-23.
//  Copyright (c) 2014年 huhoo. All rights reserved.
//

#import "CCBaseTableViewCtr.h"
#import "HHComment.h"

@interface CCBaseTableViewCtr ()
- (void)reloadData;
@end

@implementation CCBaseTableViewCtr

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

- (void)setModelDic:(NSDictionary *)modelDic
{
	_modelDic = modelDic;
	NSMutableArray* arr = [NSMutableArray array];
	NSArray* comments = modelDic[@"formsmsg"];
	for (NSDictionary* dic in comments) {
		HHComment* c = [[HHComment alloc] initWithDic:dic];
		[arr addObject:c];
	}
	self.comments = arr;
	[self reloadData];
}

- (void)reloadData
{
	[self _reloadData];
	[self.tableView reloadData];
}

- (void)_reloadData
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
