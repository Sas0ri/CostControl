//
//  NameIndex.h
//  Huhoo
//
//  Created by Sasori on 13-4-10.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameIndex : NSObject {
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger sectionNum;
@property (nonatomic) NSInteger originIndex;
@property (nonatomic) NSInteger identifier;
- (NSString *)getFirstChar;
@end