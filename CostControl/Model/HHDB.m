//
//  HHDB.m
//  Huhoo
//
//  Created by Jason Chong on 13-2-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHDB.h"
#import "HHUser.h"
#import "HHCompany.h"
#import "NSDate+convenience.h"
#import "CDAppOauth.h"

#define kUserInfoTableKey		 @"CDUserInfo"
#define kAppOauthTableKey        @"CDAppOauth"

@interface HHDB ()

@property (nonatomic, strong) NSManagedObjectContext* mainManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext* currentManagedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (void)updateContext:(NSNotification*)notification;
@end

@implementation HHDB

static HHDB* _sharedDB = nil;
static const char* kQueueLabel = "__HHDB__QUEUE__";


+(HHDB*)sharedDB
{
    if (_sharedDB == nil) {
        _sharedDB = [[HHDB alloc] init];
    }
    return _sharedDB;
}

-(void)reset
{
	_mainManagedObjectContext = nil;
	_managedObjectContext = nil;
	_currentManagedObjectContext = nil;
	_persistentStoreCoordinator = nil;
	_managedObjectModel = nil;
}

-(id)init
{
	if (self = [super init]) {
		_backgroundQueue = dispatch_queue_create(kQueueLabel, NULL);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContext:) name:NSManagedObjectContextDidSaveNotification object:nil];
	}
	return self;
}

- (NSString*)filePath
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                                                           NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.sqlite", self.uid.longLongValue]];
}

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
		_mainManagedObjectContext.undoManager = nil;
		[_mainManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext)
	{
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator)
	{		
		if ([NSManagedObjectContext instancesRespondToSelector:@selector(initWithConcurrencyType:)])
			_managedObjectContext =
			[[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
		else
			_managedObjectContext = [[NSManagedObjectContext alloc] init];
		
		_managedObjectContext.persistentStoreCoordinator = coordinator;
		_managedObjectContext.undoManager = nil;
		[_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
	}
	return _managedObjectContext;
}

- (NSManagedObjectContext *)currentManagedObjectContext
{
	return dispatch_get_current_queue() == dispatch_get_main_queue() ? self.mainManagedObjectContext : self.managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //从本地所有xcdatamodel文件中获得这个CoreData的数据模板
//    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Huhoo" ofType:@"momd"];
	NSURL *momURL = [NSURL fileURLWithPath:path];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	NSURL* storeUrl = [NSURL fileURLWithPath:[self filePath]];
    NSLog(@"filepath is %@",[self filePath]);
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:optionsDictionary error:&error]) {
		NSLog(@"Failed to init persistentstore, error is %@", error);
        NSAssert(0, @"persistentStoreCoordinator init failed!");
    }
    
    return _persistentStoreCoordinator;
}

- (void)open:(NSNumber*)uid
{
    self.uid = uid;
    if ([HHUser isUidValid:uid.integerValue]) {
		[self reset];
		[self mainManagedObjectContext];
        
    }
}

-(void) close{
    self.uid = 0;
	[self reset];
}

//- (void)insertRecentWorkers:(NSArray *)wids cid:(NSInteger)cid
//{
//    for (NSNumber* wid in wids) {
//        [self insertRecentWorker:wid cid:cid];
//    }
//}

//- (NSInteger)calendarCount
//{
//	NSFetchRequest* r = [NSFetchRequest fetchRequestWithEntityName:kCalendarTableKey];
//	NSError* err = nil;
//	NSArray* arr = [self.currentManagedObjectContext executeFetchRequest:r error:&err];
//    return arr.count;
//}

- (CDUserInfo *)findUserById:(NSInteger)uid
{
	NSFetchRequest* r = [[NSFetchRequest alloc] initWithEntityName:kUserInfoTableKey];
	NSError* err = nil;
	NSPredicate* p = [NSPredicate predicateWithFormat:@"uid = %d", uid];
	[r setPredicate:p];
	[r setFetchLimit:1];
	NSArray* arr = [self.currentManagedObjectContext executeFetchRequest:r error:&err];
	if (!arr) {
		NSLog(@"Fetch user error :%@", err);
	}
	CDUserInfo* user = nil;
	if (arr.count > 0) {
		user = [arr lastObject];
	}
	return user;
}

- (CDUserInfo *)getUserById:(NSInteger)uid
{
	NSFetchRequest* r = [[NSFetchRequest alloc] initWithEntityName:kUserInfoTableKey];
	NSError* err = nil;
	NSPredicate* p = [NSPredicate predicateWithFormat:@"uid = %d", uid];
	[r setPredicate:p];
	[r setFetchLimit:1];
	NSArray* arr = [self.currentManagedObjectContext executeFetchRequest:r error:&err];
	if (!arr) {
		NSLog(@"Fetch user error :%@", err);
	}
	CDUserInfo* user = nil;
	if (arr.count > 0) {
		user = [arr lastObject];
	} else {
		user = [NSEntityDescription insertNewObjectForEntityForName:kUserInfoTableKey inManagedObjectContext:self.currentManagedObjectContext];
		user.uid = [NSNumber numberWithInteger:uid];
	}
	return user;
}

- (CDUserInfo *)getDefaultUser
{
	CDUserInfo* user = [[CDUserInfo alloc] initWithEntity:[NSEntityDescription entityForName:kUserInfoTableKey inManagedObjectContext:self.currentManagedObjectContext] insertIntoManagedObjectContext:self.currentManagedObjectContext];
	[self.currentManagedObjectContext deleteObject:user];
	return user;
}

- (void)insertAppOauth:(HHAppOauth *)oauth
{
    CDAppOauth* ca = nil;
    NSError* err = nil;
    if (oauth.appOauthCoreDataId) {
        ca = (CDAppOauth*)[self.currentManagedObjectContext existingObjectWithID:oauth.appOauthCoreDataId error:&err];
        if (err) {
            NSLog(@"Fetch app oauth error:%@",err);
        }
        
    }
    else
    {
        ca = [NSEntityDescription insertNewObjectForEntityForName:kAppOauthTableKey inManagedObjectContext:self.currentManagedObjectContext];
    }
    if (ca) {
        [ca copyWithHHAppOauth:oauth];
        [self save];
    }
	
}

-(void)removeAppOauth:(HHAppOauth *)oauth
{
    if (oauth.appOauthCoreDataId) {
        NSError* err = nil;
        CDAppOauth* ca = (CDAppOauth*)[self.currentManagedObjectContext existingObjectWithID:oauth.appOauthCoreDataId error:&err];
        if (ca) {
            [self.currentManagedObjectContext deleteObject:ca];
        }
        [self save];
    }
    
}

- (HHAppOauth*)loadAppOauthsWithUid:(NSNumber*)uid customerKey:(NSString *)customerKey
{
    NSFetchRequest* r = [[NSFetchRequest alloc] init];
	[r setEntity:[NSEntityDescription entityForName:kAppOauthTableKey inManagedObjectContext:self.currentManagedObjectContext]];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"uid == %d AND customerKey == %@", uid.integerValue, customerKey];
    [r setPredicate:p];
	NSError* err = nil;
 	NSArray* oauths = [self.currentManagedObjectContext executeFetchRequest:r error:&err];
	if (!oauths) {
		NSLog(@"fetch oauths error %@",err);
	}
	if (oauths.count > 0) {
        CDAppOauth* c = [oauths objectAtIndex:0];
        return [c HHAppOauth];
	}
	return nil;
}


-(void)save
{
	NSError* err = nil;
	if (![self.currentManagedObjectContext save:&err]) {
		[self.currentManagedObjectContext rollback];
		NSLog(@"%@",err);
	}
}

- (void)updateContext:(NSNotification *)notification
{
	if (notification.object == self.mainManagedObjectContext) {
		dispatch_async(self.backgroundQueue, ^{
			[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
		});
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
		});
	}
}

- (void)dealloc
{
}

@end
