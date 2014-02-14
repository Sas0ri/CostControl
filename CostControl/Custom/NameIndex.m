//
//  NameIndex.m
//  Huhoo
//
//  Created by Sasori on 13-4-10.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "NameIndex.h"
#import "Pinyin.h"

@implementation NameIndex

- (NSString *) getFirstChar {
    if ([[_name substringToIndex:1] canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
        return _name;
    }
    else { //如果是非英语
		NSString* c = [NSString stringWithFormat:@"%c",[Pinyin pinyinFirstLetter:[_name characterAtIndex:0]]];
		return c;
    }
}

@end