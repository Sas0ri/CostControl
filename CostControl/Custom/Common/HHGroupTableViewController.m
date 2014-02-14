//
//  HHGroupTableViewController.m
//  Huhoo
//
//  Created by Sasori on 13-10-16.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHGroupTableViewController.h"

@interface HHGroupTableViewController ()

@end

@implementation HHGroupTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIView* v = [[UIView alloc] init];
	v.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = v;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor whiteColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* v = [[UIView alloc] init];
	v.backgroundColor = [UIColor clearColor];
	return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

@end
