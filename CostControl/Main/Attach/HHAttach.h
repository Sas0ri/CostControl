//
//  HHAttach.h
//  Huhoo
//
//  Created by Jason Chong on 13-3-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHAttach : NSObject

@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) UIImage* fileIcon;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* fileType;

+ (NSArray*)validAttachTypes;

@end
