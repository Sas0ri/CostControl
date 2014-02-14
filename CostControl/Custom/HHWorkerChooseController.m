//
//  HHWorkerChooseController.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-25.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHWorkerChooseController.h"
#import "HHCompany.h"
#import "HHWorkerChooseCell.h"
//#import "HHAppDelegate.h"
#import "NameIndex.h"
#import "SearchCoreManager.h"
#import "HHUtils.h"
#import "HHDB.h"
#import "HHAccount.h"

@interface WorkerItem : NSObject

@property (nonatomic, strong) NSNumber* wid;
@property (assign, nonatomic) BOOL isChecked;

@end

@implementation WorkerItem


@end

@interface HHWorkerChooseController ()

@property (nonatomic, strong) HHCompany* company;
@property (nonatomic, strong) NSMutableArray* dataSource;//array of array
@property (nonatomic, strong) NSMutableArray* sectionTitles;
@property (nonatomic, strong) UILocalizedIndexedCollation* collation;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (nonatomic, assign) BOOL hasInit;
@property (nonatomic, strong) NSDictionary* workerItems;
@property (nonatomic, strong) HHGlowTitleButton* backButton;
@property (nonatomic, strong) CMIndexBar* indexBar;

- (void)updateStruct:(id)sender;
- (void)prepareForDataSource;

@end

@implementation HHWorkerChooseController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStruct:) name:kStructHasUpdatedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton* button = [HHUtils navDoneButton];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    self.tableView.allowsMultipleSelection = self.allowsMultipleSelection;
    
	self.searchResults = [NSMutableArray array];
	UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];//这个是建立索引的核心
	self.collation = theCollation;
    [self.tableView reloadData];
    
	CMIndexBar *indexBar = [[CMIndexBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20, 66, 20, self.view.frame.size.height - 66)];
	indexBar.delegate = self;
	self.indexBar = indexBar;
}

- (void)indexSelectionDidChange:(CMIndexBar *)indexBar index:(NSInteger)index title:(NSString *)title
{
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)done
{
    [self.selectedWorkers removeAllObjects];
    for (WorkerItem* workerItem in self.workerItems.allValues) {
        if (workerItem.isChecked) {
            [self.selectedWorkers addObject:workerItem.wid];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(workerChooseController: workersChoosed:)]) {
        [self.delegate workerChooseController:self workersChoosed:self.selectedWorkers];
    }
    if (self.completionBlock) {
        self.completionBlock(self.selectedWorkers);
        self.completionBlock = NULL;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.hasInit) {
		return;
	}
	self.hasInit = YES;
	[self prepareForDataSource];
    for (NSNumber* wid in self.selectedWorkers) {
        for (WorkerItem* workerItem in self.workerItems.allValues) {
            if ([workerItem.wid isEqualToNumber:wid]) {
                workerItem.isChecked = YES;
                break;
            }
        }
    }
	[self.tableView reloadData];
	[[UIApplication sharedApplication].keyWindow addSubview:self.indexBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.indexBar removeFromSuperview];
	[super viewWillDisappear:animated];
}

- (void)prepareForDataSource
{
	NSMutableArray* temp = [NSMutableArray arrayWithCapacity:[self.company workersCache].allValues.count];
	NSMutableArray* sectionTitles = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* tempWorkerItems = [[NSMutableDictionary alloc] initWithCapacity:self.company.workersCache.count];
	[[SearchCoreManager share] Reset];
	for (int i = 0 ; i < [self.company workersCache].allValues.count ; i++) {
		HHWorker* worker = [self.company.workersCache.allValues objectAtIndex:i];
		if (self.candidatedWorkers.count > 0) {
			if (![self.candidatedWorkers containsObject:worker.wid]) {
				continue;
			}
		}
		if ([HHAccount sharedAccount].uid.longLongValue == worker.uid.longLongValue) {
			continue;
		}
		NameIndex* nameIndex = [[NameIndex alloc] init];
		nameIndex.name = worker.name.length > 0 ? worker.name : worker.nickname;
        nameIndex.identifier = worker.wid.integerValue;
		nameIndex.originIndex = i;
		[temp addObject:nameIndex];
		[[SearchCoreManager share] AddContact:[NSNumber numberWithInt:i] name:nameIndex.name phone:nil];
        
        WorkerItem* workerItem = [[WorkerItem alloc] init];
        workerItem.wid = worker.wid;
        workerItem.isChecked = NO;
        [tempWorkerItems setObject:workerItem forKey:workerItem.wid];
	}
    self.workerItems = tempWorkerItems;
	for (NameIndex* item in temp) {
		NSInteger sect = [self.collation sectionForObject:item collationStringSelector:@selector(getFirstChar)];//getName是实现中文安拼音检索的核心，见NameIndex类
        item.sectionNum = sect; //设定姓的索引编号
    }
    NSInteger highSection = [[self.collation sectionTitles] count]; //返回的应该是27，是a－z和＃
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection]; //tableView 会被分成27个section
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (NameIndex *item in temp) {
        NSMutableArray* sectionArray = (NSMutableArray *)[sectionArrays objectAtIndex:item.sectionNum];
        [sectionArray addObject:item];
    }
	
	temp = [NSMutableArray array];
	for (NSArray* array in sectionArrays) {
		if (array.count > 0) {
			[temp addObject:array];
		}
	}
	self.dataSource = temp;
	for (int i = 0; i < self.dataSource.count; i++) {
		NSArray* array = [self.dataSource objectAtIndex:i];
		NameIndex* item = [array objectAtIndex:0];
		NSInteger sect = [self.collation sectionForObject:item collationStringSelector:@selector(getFirstChar)];
		NSString* title = [[self.collation sectionTitles] objectAtIndex:sect];
		[sectionTitles addObject:[title uppercaseString]];
	}
	self.sectionTitles = sectionTitles;
	[self.indexBar setIndexes:sectionTitles];
    
}

- (void)setCid:(NSInteger)cid
{
    _cid = cid;
    self.company = [HHCompany findCompanyWithId:cid];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.tableView) {
		return self.dataSource.count;
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		return [self.sectionTitles objectAtIndex:section];
	}
	return nil;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//	if (tableView == self.tableView) {
//		return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.sectionTitles];
//	}
//	return nil;
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	if (tableView == self.tableView) {
//		return index-1;
//	}
//	return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		NSArray* array = [self.dataSource objectAtIndex:section];
		return array.count;
	}
	return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkerChooseCell";
    HHWorkerChooseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
		NSInteger index = -1;
		if (tableView == self.tableView) {
			NSArray* array = [self.dataSource objectAtIndex:indexPath.section];
			NameIndex* item = [array objectAtIndex:indexPath.row];
			index = item.originIndex;
		} else {
			index = ((NSNumber*)[self.searchResults objectAtIndex:indexPath.row]).integerValue;
		}
        
		HHWorker* worker = [[[self.company workersCache] allValues] objectAtIndex:index];
		if (worker) {
			HHDept* dep = [self.company findDept:worker.did];
			NSString* avatarUrl = worker.avatarUrl;
			if (!avatarUrl) {
				CDUserInfo* u = [[HHDB sharedDB] findUserById:worker.uid.integerValue];
				if (u) {
					avatarUrl = u.headpicUrl;
				}
			}
			cell.name = worker.name;
			cell.avatarUrl = avatarUrl;
			cell.wid = worker.wid;
			cell.dept = dep.name;
            [cell showSelectedImage:NO];
            
            WorkerItem* workerItem = [self.workerItems objectForKey:cell.wid];
            if (workerItem) {
				if (workerItem.isChecked) {
					[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
					[cell showSelectedImage:workerItem.isChecked];
				}
			}
		}
		return cell;
	}
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"numberbg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
	UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 27)];
	title.text = [self.sectionTitles objectAtIndex:section];
	title.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
	title.font = [UIFont boldSystemFontOfSize:12];
	title.backgroundColor = [UIColor clearColor];
	[imageView addSubview:title];
	return imageView;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
	[tableView registerClass:[HHWorkerChooseCell class] forCellReuseIdentifier:@"WorkerChooseCell"];
#endif
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchResults phoneMatch:nil];
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = self.allowsMultipleSelection;
    [self.searchDisplayController.searchResultsTableView reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHWorkerChooseCell* cell = (HHWorkerChooseCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        WorkerItem* workerItem = [self.workerItems objectForKey:cell.wid];
        if (workerItem) {
            workerItem.isChecked = YES;
            [cell showSelectedImage:workerItem.isChecked];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHWorkerChooseCell* cell = (HHWorkerChooseCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        WorkerItem* workerItem = [self.workerItems objectForKey:cell.wid];
        if (workerItem) {
            workerItem.isChecked = NO;
            [cell showSelectedImage:workerItem.isChecked];
        }
    }
}

- (void)updateStruct:(id)sender
{
	NSNotification* n = (NSNotification*)sender;
	NSDictionary* dic = n.userInfo;
	NSInteger cid = ((NSNumber*)[dic objectForKey:@"cid"]).integerValue;
	if (cid != self.cid) {
		return;
	}
	[self prepareForDataSource];
	[self.tableView reloadData];
}


@end
