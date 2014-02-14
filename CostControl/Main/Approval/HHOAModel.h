//
//  HHOAModel.h
//  Huhoo
//
//  Created by Jason Chong on 13-5-2.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HHOAModel : NSObject

- (NSInteger)count;
- (NSArray*)topIndexItems:(NSInteger)count;
- (void)updateIfNeed;

@end

@interface HHOACellIndexItem : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subTitle;

@end
