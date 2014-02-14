//
//  HHUtils.m
//  Huhoo
//
//  Created by Jason Chong on 13-1-11.
//  Copyright (c) 2013Âπ?Huhoo. All rights reserved.
//

#import "HHUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "HHOpenClient.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
//#import "NSData+Base64.h"
//#import "NSString+Base64.h"
#import "FlatUIKit.h"
#import "UIColor+expanded.h"
#define kEncryptPassword    @"Huhoo.Mobile_"

#ifdef HHDEBUG

#if HHDEBUG_ON_243
	static NSString* const kHHOpenBaseURLString = @"http://192.168.0.243/";
#else
	static NSString* const kHHOpenBaseURLString = @"http://192.168.0.245/";
#endif

#else

#ifdef HH_PUBLIC_HOST_IP
	static NSString * const kHHOpenBaseURLString = @"http://122.144.130.250/";
#else
	static NSString * const kHHOpenBaseURLString = @"http://ccs.huhoo.com/";
#endif

#endif

@implementation HHUtils

+(UIButton*)navButtonWithTitle:(NSString *)title frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    UIImage *navButtonImage = [UIImage imageNamed:@"NavButton"];
    UIImage *stretchableNavButtonImage = [navButtonImage
                                          stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    [button setBackgroundImage:stretchableNavButtonImage forState:UIControlStateNormal];
    
    UIImage *navButtonImagePressed = [UIImage imageNamed:@"NavButton_down"];
    UIImage *stretchableNavButtonImagePressed = [navButtonImagePressed
                                                 stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    [button setBackgroundImage:stretchableNavButtonImagePressed forState:UIControlStateSelected];
    [button setBackgroundImage:stretchableNavButtonImagePressed forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    button.titleLabel.font = kNavButtonTitleFont;
    button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
    button.titleLabel.layer.shadowOpacity = 0.5;
    button.titleLabel.layer.shadowRadius = 1;
    
    return button;
}

+(UIButton*)navLeftButtonWithTitle:(NSString *)title
{
	UIFont *font = kNavButtonTitleFont;
	CGRect frame = CGRectMake(0, 7, 44.0, 30.0);
    CGFloat textWidth = [title sizeWithFont:font
                          constrainedToSize:CGSizeMake(160, 30)
                              lineBreakMode:NSLineBreakByTruncatingTail].width;
    textWidth += 36;
    frame.size.width = MAX(textWidth, frame.size.width);
    frame.origin.x = 0;
	FUIButton* button = [[FUIButton alloc] initWithFrame:frame];
	button.buttonColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor colorWithHexString:@"5B9E29"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"5B9E29"] forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateNormal];
	
	UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back"]];
	image.frame = CGRectMake(0, 0, 15, 30);
	[button addSubview:image];
	image.contentMode = UIViewContentModeCenter;
	button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
	[button setShadowHeight:0];
	return button;
}

+ (HHGlowTitleButton*)navGlowLeftButtonWithTitle:(NSString *)title
{
    UIFont *font = kNavButtonTitleFont;
    CGRect frame = CGRectMake(0, 7, 44.0, 30.0);
    CGFloat textWidth = [title sizeWithFont:font
                          constrainedToSize:CGSizeMake(160, 30)
                              lineBreakMode:NSLineBreakByTruncatingTail].width;
    textWidth += 16;
    frame.size.width = MAX(textWidth, frame.size.width);
    HHGlowTitleButton* button = [[HHGlowTitleButton alloc] initWithFrame:frame];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    [button.button setBackgroundImage:[[UIImage imageNamed:@"nav_button_bg"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [button.button setBackgroundImage:[[UIImage imageNamed:@"nav_button_bg_down"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    button.glowLabel.text = title;
    button.glowLabel.font = font;
    
    return button;
}

+(UIButton*)navRightButtonWithTitle:(NSString *)title
{
	UIFont *font = kNavButtonTitleFont;
    CGRect frame = CGRectMake(320-44, 7, 44.0, 30.0);
    CGFloat textWidth = [title sizeWithFont:font
                          constrainedToSize:CGSizeMake(160, 30)
                              lineBreakMode:NSLineBreakByTruncatingTail].width;
    textWidth += 16;
    frame.size.width = MAX(textWidth, frame.size.width);
    frame.origin.x = 320 - frame.size.width;
	FUIButton* button = [[FUIButton alloc] initWithFrame:frame];
	button.buttonColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor colorWithHexString:@"5B9E29"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"5B9E29"] forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateNormal];
	return button;
}

+ (HHGlowTitleButton*)navGlowRightButtonWithTitle:(NSString *)title
{
    UIFont *font = kNavButtonTitleFont;
    CGRect frame = CGRectMake(320-44, 7, 44.0, 30.0);
    CGFloat textWidth = [title sizeWithFont:font
                          constrainedToSize:CGSizeMake(160, 30)
                              lineBreakMode:NSLineBreakByTruncatingTail].width;
    textWidth += 16;
    frame.size.width = MAX(textWidth, frame.size.width);
    frame.origin.x = 320 - frame.size.width;
    HHGlowTitleButton* button = [[HHGlowTitleButton alloc] initWithFrame:frame];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    [button.button setBackgroundImage:[[UIImage imageNamed:@"nav_button_bg"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [button.button setBackgroundImage:[[UIImage imageNamed:@"nav_button_bg_down"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    button.glowLabel.text = title;
    button.glowLabel.font = font;
    
    return button;
}


+ (UIButton*)navLeftButtonWithIconNormal:(UIImage *)iconNormal iconHighlighted:(UIImage *)iconHighlighted
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 44, 30)];
	//    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_bg.png"] forState:UIControlStateNormal];
	//    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_bg_down.png"] forState:UIControlStateHighlighted];
    [button setImage:iconNormal forState:UIControlStateNormal];
	[button setImage:iconHighlighted forState:UIControlStateHighlighted];
    return button;
}



+ (UIButton*)navBackButton
{
    return [HHUtils navLeftButtonWithIconNormal:[UIImage imageNamed:@"nav_back.png"] iconHighlighted:[UIImage imageNamed:@"nav_back_down.png"]];
}

+ (UIButton*)navRightButtonWithIconNormal:(UIImage *)iconNormal iconHighlighted:(UIImage *)iconHighlighted
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(276, 7, 44, 30)];
	//    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_bg.png"] forState:UIControlStateNormal];
	//    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_bg_down.png"] forState:UIControlStateHighlighted];
    [button setImage:iconNormal forState:UIControlStateNormal];
	[button setImage:iconHighlighted forState:UIControlStateHighlighted];
    return button;
}

+ (UILabel *)navTitleView
{
	return [self navTitleViewWithText:nil];
}

+ (UILabel *)navTitleViewWithText:(NSString *)title
{
	CGRect frame = CGRectMake(0.0, 0.0, 320, 44);
    UILabel* _navTitleView = [[UILabel alloc] initWithFrame:frame];
    _navTitleView.textAlignment = NSTextAlignmentCenter;
    _navTitleView.backgroundColor = [UIColor clearColor];
    _navTitleView.textColor = [UIColor blackColor];
    _navTitleView.font = [UIFont boldSystemFontOfSize:20.0];
    _navTitleView.text = title;
	return _navTitleView;
}

+ (UIButton*)navDoneButton
{
    return [HHUtils navRightButtonWithIconNormal:[UIImage imageNamed:@"nav_done.png"] iconHighlighted:[UIImage imageNamed:@"nav_done_down.png"]];
}

+ (int)randomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (NSString*)timeStamp
{
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    
}


+ (NSDate*)dateFromString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d H:mm:ss"];
    return [formatter dateFromString:string];
}

+(NSString*)dateTimeString:(NSDate *)date  withTime:(BOOL)withTime withSec:(BOOL)withSec
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([date year] != [[NSDate date] year]) {
        [formatter setDateFormat:@"yyyy-M-d"];
    }
    else
    {
        [formatter setDateFormat:@"M-d"];
    }
    
    
    NSString* formatStr = nil;
	if (withSec) {
		formatStr = @"H:mm:ss";
	} else {
		formatStr = @"H:mm";
	}
    NSDate *dateNow = [NSDate date];
    NSTimeInterval secondsPerDay = 24*60*60;
    NSDate *dateYestoday = [NSDate dateWithTimeInterval:-secondsPerDay sinceDate:dateNow];
    NSString *strDate;
    if ([[formatter stringFromDate:dateNow] isEqualToString: [formatter stringFromDate:date]]) {
        [formatter setDateFormat:formatStr];
        return [formatter stringFromDate:date];
    }
    else if ([[formatter stringFromDate:dateYestoday] isEqualToString: [formatter stringFromDate:date]]) {
        strDate = @"昨天";
    }
    else {
        strDate = [formatter stringFromDate:date];
    }
    if (!withTime) {
        return strDate;
    }
    [formatter setDateFormat:formatStr];
    return [NSString stringWithFormat:@"%@ %@", strDate, [formatter stringFromDate:date]];
}

+(NSString*)standardDateTimeString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)standardDateDayString:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d"];
    return [formatter stringFromDate:date];
}

+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [dateFormatter stringFromDate:nowUTC];
    
}

+(NSString *)urlStrForImage:(NSString *)img
{
	//"http://cache.huhoo.cn/img/5a18350026a6ba0cd0cc048f10373ae8d66ca43e.jpg"
	return [NSString stringWithFormat:@"%@img/%@",kHHCacheURLString,img];
}

+(NSString *)urlStrForImageMobile:(NSString *)img
{
	NSString * fileName;//文件名
	NSRange range = [img rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.length > 0)
	{
        fileName = [NSString stringWithFormat:@"%@_mobile.%@",[img substringToIndex:range.location],[img substringFromIndex:NSMaxRange(range)]];
		fileName = [NSString stringWithFormat:@"%@img2/%@",kHHCacheURLString,fileName];
	}
	return fileName;
}

+ (NSString*) stringWithUUID {
	CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

+ (NSData *)UIImageJPEGLowQuality:(UIImage *)image
{
	NSData* data = UIImageJPEGRepresentation(image, 0.6);
	return data;
}

+ (NSNumber*)numberIdFromJsonId:(id)jsonId
{
    if (!jsonId) {
        return nil;
    }
    if ([jsonId isKindOfClass:[NSString class]]) {
        NSString* strId = jsonId;
        return [NSNumber numberWithLongLong:[strId longLongValue]];
    }
    if ([jsonId isKindOfClass:[NSNumber class]]) {
        return jsonId;
    }
    return nil;
}

//16Ëø??È¢??(htmlÈ¢????Â≠??‰∏≤ËΩ¨‰∏?IColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	// String should be 6 or 8 characters
	
	if ([cString length] < 6) return [UIColor blackColor];
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
	if ([cString length] != 6) return [UIColor blackColor];
	
	// Separate into r, g, b substrings
	
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	// Scan values
	unsigned int r, g, b;
	
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}


+ (NSString *)stringForBytes:(NSInteger)bytes
{
	if (bytes > 1000*1000*1000) {
		return [NSString stringWithFormat:@"%.1fG", bytes/1000.0/1000/1000];
	}
	if (bytes > 1000*1000) {
		return [NSString stringWithFormat:@"%.1fM", bytes/1000.0/1000];
	}
	if (bytes > 1000) {
		return [NSString stringWithFormat:@"%.1fK", bytes/1000.0];
	}
	return [NSString stringWithFormat:@"%ld", (long)bytes];
}


+ (NSString*)validateString:(id)str
{
	if ([str isKindOfClass:[NSString class]]) {
		return (NSString*)str;
	} else {
		return @"";
	}
}

+ (NSNumber*)validateNumber:(id)num
{
	if ([num isKindOfClass:[NSNumber class]]) {
		return (NSNumber*)num;
	} else {
		return @0;
	}
}


//+ (NSString *)encrypt:(NSString *)message
//{
//    return [AESCrypt encrypt:message password:kEncryptPassword];
//}
//
//+ (NSString*)decrypt:(NSString *)base64EncodedString
//{
//    return [AESCrypt decrypt:base64EncodedString password:kEncryptPassword];
//}
//
//+ (NSString *)toBase64String:(NSString *)string {
//    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
//    
//    NSString *ret = [NSString base64StringFromData:data length:[data length]];
//    
//    return ret;
//}
//
//+ (NSString *)fromBase64String:(NSString *)string {
//    NSData  *base64Data = [NSData base64DataFromString:string];
//    
//    NSString* decryptedStr = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
//    
//    return decryptedStr;
//}

+ (NSString *)getIPAddress
{
#if TARGET_IPHONE_SIMULATOR
	return @"192.168.0.2";
#endif
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
	
}

+ (BOOL)isPhoneNumber:(NSString *)mobileNum
{
	/**
	 * 手机号码
	 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 * 联通：130,131,132,152,155,156,185,186
	 * 电信：133,1349,153,180,189
	 */
	NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
	/**
	 10         * 中国移动：China Mobile
	 11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 12         */
	NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
	/**
	 15         * 中国联通：China Unicom
	 16         * 130,131,132,152,155,156,185,186
	 17         */
	NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
	/**
	 20         * 中国电信：China Telecom
	 21         * 133,1349,153,180,189
	 22         */
	NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
	/**
	 25         * 大陆地区固话及小灵通
	 26         * 区号：010,020,021,022,023,024,025,027,028,029
	 27         * 号码：七位或八位
	 28         */
	NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
	NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];	
	NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
		|| ([regextestcm evaluateWithObject:mobileNum] == YES)
		|| ([regextestct evaluateWithObject:mobileNum] == YES)
		|| ([regextestcu evaluateWithObject:mobileNum] == YES)
		|| ([regextestphs evaluateWithObject:mobileNum]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)avatarUrlString:(NSString *)str
{
	if ([str hasPrefix:@"http://"]) {
		return str;
	}
	return [NSString stringWithFormat:@"%@%@", kHHCacheURLString,str];
}

+ (NSString *)regularStringFromDic:(id)dic
{
	if ([dic respondsToSelector:@selector(doubleValue)]) {
		return [NSString stringWithFormat:@"%0.2f", [dic doubleValue]];
	}
	return @"0.00";
}

+ (NSString *)trimDepartment:(NSString *)dept
{
	if ([dept hasPrefix:@"/"]) {
		dept = [dept substringFromIndex:1];
	}
	if ([dept hasSuffix:@"/"]) {
		dept = [dept substringToIndex:dept.length-1];
	}
	return dept;
}

+ (NSString *)getLeafDepartmentString:(NSString *)dept
{
	if ([dept rangeOfString:@"/"].location != NSNotFound) {
		dept = [self trimDepartment:dept];
		NSArray* arr = [dept componentsSeparatedByString:@"/"];
		return [arr lastObject];
	} else {
		return dept;
	}
}

@end
