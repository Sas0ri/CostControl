//
//  HHDB.h
//  Huhoo
//
//  Created by Jason Chong on 13-2-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHCompany.h"
#import "CDUserInfo.h"
#import "HHAppOauth.h"

@interface HHDB : NSObject

@property (nonatomic, strong)NSNumber *uid;

+(HHDB*)sharedDB;
-(void)open:(NSNumber*)uid;
- (void)close;
//-(void)insertRecentWorker:(NSNumber*)wid cid:(NSInteger)cid;
//-(void)insertRecentWorkers:(NSArray*)wids cid:(NSInteger)cid;
//-(NSArray*)getCompanyRecentWorkers:(NSInteger)cid;
//- (void)updateCompany:(HHCompany*)company;
//- (void)removeCommanyById:(NSInteger)cid;
//- (HHCompany*)loadCompany:(NSInteger)cid;
//- (NSArray*)loadCompanys;
//- (void)insertChatMessage:(HHChatMessage*)message;
//- (void)removeChatMessageById:(NSString*)jid;
//- (void)removeAllChatMessages;
//- (void)insertAllChatMessageFromCache;
//- (NSInteger)chatMessageCount:(NSString*)jid;
//- (NSArray*)loadMessage:(NSString*)jid offset:(NSInteger)offset count:(NSInteger)count;

//- (NSArray*)loadRepeatCalendarWithRepeatType:(CalendarRepeatIntervalType)type;
//- (NSArray*)loadRepeatCalendarWithDate:(NSDate*)date;
//- (NSArray*)loadCalendarWithDate:(NSDate*)date;
//- (NSArray*)loadCalendarWithMonth:(NSDate*)month;
//- (NSArray*)datesHasCalendarInMonth:(NSDate*)month;
//- (void)insertCalendar:(HHCalendar*)calendar;
//- (void)removeCalendar:(HHCalendar *)calendar;
//- (NSInteger)calendarCount;

//- (NSArray*)loadOAApps;
//- (void)updateOAApps:(NSArray*)apps;
//
//- (NSArray*)loadServices;
//- (void)updateServices:(NSArray*)services;
//
- (void)insertAppOauth:(HHAppOauth*)oauth;
- (void)removeAppOauth:(HHAppOauth*)oauth;
- (HHAppOauth*)loadAppOauthsWithUid:(NSNumber*)uid customerKey:(NSString*)customerKey;

//- (NSArray*)getLastMsgs;
//- (void)insertLastMsg:(HHChatMessage*)message unread:(BOOL)b;
//- (void)removeLastMsgById:(NSString*)msgId;
//- (void)setLastMsgRead:(HHChatMessage*)message;
//- (void)removeAllLastMsgs;
- (void)reset;
- (void)save;
//- (NSArray*)getRosters;
//- (Roster *)userForJID:(XMPPJID *)jid;
//- (Roster*)getRosterById:(XMPPJID*)jid;
//- (void)removeRoster:(Roster*)r;
//- (void)removeRosterByID:(NSString*)jid;
//- (void)insertChatGroup:(HHChatGroup*)group;
//- (void)removeChatGroup:(HHChatGroup*)group;
//- (NSArray*)loadGroups;
//- (HHChatGroup*)groupWithID:(NSString*)jid;
- (CDUserInfo*)findUserById:(NSInteger)uid;
- (CDUserInfo*)getUserById:(NSInteger)uid;
- (CDUserInfo*)getDefaultUser;
//- (SystemMessage*)findMessageById:(NSString*)jid;
//- (SystemMessage*)getMessageById:(NSString*)jid;
//- (void)removeMessageById:(NSString*)jid;
//- (NSArray*)getAllSystemMessages;
//- (void)removeAllSystemMessages;
//- (RosterGroup*)getRosterGroupWithName:(NSString*)groupName;
//- (NSArray*)getAllRosterGroup;
//- (void)addRoster:(Roster*)roster ToGroup:(NSString*)groupName;
//- (ChatRoom*)getChatRoomById:(NSString*)jid;
//- (ChatRoom*)findChatRoomById:(NSString*)jid;
//- (void)removeChatRoomById:(NSString*)jid;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

@end
