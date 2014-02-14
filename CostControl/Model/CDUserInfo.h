//
//  CDUserInfo.h
//  Huhoo
//
//  Created by Sasori on 13-7-2.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatRoom;

@interface CDUserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * area;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * ext;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headpicUrl;
@property (nonatomic, retain) NSNumber * member;
@property (nonatomic, retain) NSString * msn;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * province;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSNumber * stamp;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * vip;
@property (nonatomic, retain) NSNumber * wid;
@property (nonatomic, retain) NSSet *room;

- (void)configWithDictionary:(NSDictionary*)dic;

@end

@interface CDUserInfo (CoreDataGeneratedAccessors)

- (void)addRoomObject:(ChatRoom *)value;
- (void)removeRoomObject:(ChatRoom *)value;
- (void)addRoom:(NSSet *)values;
- (void)removeRoom:(NSSet *)values;

@end
