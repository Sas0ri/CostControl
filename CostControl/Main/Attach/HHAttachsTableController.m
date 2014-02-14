//
//  HHAttachsTableController.m
//  Huhoo
//
//  Created by Jason Chong on 13-7-4.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHAttachsTableController.h"
#import "HHAttachController.h"

@interface HHAttachsTableController ()

@end

@implementation HHAttachsTableController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([sender respondsToSelector:@selector(attach)] && [destination respondsToSelector:@selector(setAttach:)]) {
            [destination setValue:[sender valueForKey:@"attach"] forKey:@"attach"];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttachCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell && [cell respondsToSelector:@selector(setAttach:)]) {
        [cell setValue:[self.attachs objectAtIndex:indexPath.row] forKey:@"attach"];
    }
    
    return cell;
}


@end
