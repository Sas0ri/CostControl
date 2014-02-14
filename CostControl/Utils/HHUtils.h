//
//  HHUtils.h
//  Huhoo
//
//  Created by Jason Chong on 13-1-11.
//  Copyright (c) 2013Âπ?Huhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHGlowTitleButton.h"

#define kTabSelectedImageTintColor  [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:149/255.0 alpha:1.0]

#define kTabelSelectedCellBG [UIColor colorWithRed:136.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1.0]

#define kNavButtonTitleFont [UIFont boldSystemFontOfSize:16.0f]

#define kInputBarMinHeight  44.0



@interface HHUtils : NSObject

+(UIButton*)navButtonWithTitle:(NSString *)title frame:(CGRect)frame;
+(UIButton*)navLeftButtonWithTitle:(NSString *)title;
+(UIButton*)navRightButtonWithTitle:(NSString *)title;

+(HHGlowTitleButton*)navGlowLeftButtonWithTitle:(NSString *)title;
//+(HHGlowTitleButton*)navGlowRightButtonWithTitle:(NSString *)title;

+ (UIButton*)navLeftButtonWithIconNormal:(UIImage*)iconNormal iconHighlighted:(UIImage*)iconHighlighted;
+ (UIButton*)navRightButtonWithIconNormal:(UIImage*)iconNormal iconHighlighted:(UIImage*)iconHighlighted;
+(UIButton*)navBackButton;
+(UIButton*)navDoneButton;
+ (UILabel*)navTitleView;
+ (UILabel*)navTitleViewWithText:(NSString*)title;

+ (int)randomNumber:(int)from to:(int)to;
+ (NSString*)timeStamp;

+ (NSDate*)dateFromString:(NSString*)string;
+ (NSString*)dateTimeString:(NSDate*)date withTime:(BOOL)withTime withSec:(BOOL)withSec;
+ (NSString*)standardDateTimeString:(NSDate*)date;
+ (NSString*)standardDateDayString:(NSDate *)date;
+(NSString *)getCurrentTime;
//+ (NSInteger)uidFromJid:(NSString*)jid;
//+ (NSInteger)groupUidFromeJid:(NSString*)jid;
//+ (NSString*)jidFromUid:(NSInteger)uid;
//+ (NSString*)groupJidFromUid:(NSInteger)uid;
//+ (HHAppDelegate *)appDelegate;
+ (NSString*)urlStrForImage:(NSString*)img;
+ (NSString*)urlStrForImageMobile:(NSString *)img;
+ (NSString*)stringWithUUID;
+ (NSData*)UIImageJPEGLowQuality:(UIImage*)image;
//+ (NSString*)groupChatIdToUserId:(NSString*)groupChatId;
+ (NSNumber*)numberIdFromJsonId:(id)jsonId;
+ (UIColor *)hexStringToColor:(NSString *) stringToConvert;

+ (NSString*)stringForBytes:(NSInteger)bytes;
+ (NSString*)validateString:(id)str;
+ (NSNumber*)validateNumber:(id)num;

//+ (NSString *)encrypt:(NSString *)message;
//+ (NSString *)decrypt:(NSString *)base64EncodedString;
//+ (NSString *)toBase64String:(NSString *)string;
//+ (NSString *)fromBase64String:(NSString *)string;
+ (NSString *)getIPAddress;
+ (BOOL)isPhoneNumber:(NSString *)mobileNum;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (NSString*)avatarUrlString:(NSString*)str;
+ (NSString*)regularStringFromDic:(id)dic;
+ (NSString*)trimDepartment:(NSString*)dept;
+ (NSString*)getLeafDepartmentString:(NSString*)dept;
@end
