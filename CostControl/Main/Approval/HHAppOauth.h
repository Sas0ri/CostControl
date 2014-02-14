//
//  HHAppOauth.h
//  Huhoo
//
//  Created by Jason Chong on 13-4-22.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/NSManagedObjectID.h"

@interface HHAppOauth : NSObject

@property (nonatomic, retain) NSString * customerKey;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * tokenSecret;
@property (nonatomic, retain) NSManagedObjectID* appOauthCoreDataId;


@end
