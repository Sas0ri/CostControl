//
//  CDUserInfo.m
//  Huhoo
//
//  Created by Sasori on 13-7-2.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "CDUserInfo.h"
#import "HHUtils.h"

@implementation CDUserInfo

@dynamic area;
@dynamic birthday;
@dynamic city;
@dynamic email;
@dynamic ext;
@dynamic gender;
@dynamic headpicUrl;
@dynamic member;
@dynamic msn;
@dynamic nickname;
@dynamic position;
@dynamic province;
@dynamic qq;
@dynamic realname;
@dynamic signature;
@dynamic stamp;
@dynamic tel;
@dynamic uid;
@dynamic vip;
@dynamic wid;
@dynamic room;

- (void)configWithDictionary:(NSDictionary *)dic
{
	self.uid = [dic objectForKey:@"uid"];;
	self.nickname = [dic objectForKey:@"nickname"];
	self.headpicUrl = [dic objectForKey:@"headpic_url"];
	self.signature = [HHUtils validateString:[dic objectForKey:@"signature"]];
	self.gender = [dic objectForKey:@"gender"];
	self.area = [dic objectForKey:@"area"];
	self.birthday = [dic objectForKey:@"birthday"];
	self.city = [dic objectForKey:@"city"];
	NSString* email = [HHUtils validateString:[dic objectForKey:@"email"]];
	if ([HHUtils isValidateEmail:email]) {
		self.email = email;
	}
	self.member = [dic objectForKey:@"member"];
	self.msn = [HHUtils validateString:[dic objectForKey:@"msn"]];
	self.position = [HHUtils validateString:[dic objectForKey:@"position"]];
	self.province = [HHUtils validateNumber:[dic objectForKey:@"province"]];
	self.qq = [HHUtils validateString:[dic objectForKey:@"qq"]];
	self.realname = [dic objectForKey:@"realname"];
	self.tel = [HHUtils validateString:[dic objectForKey:@"tel"]];
	self.vip = [dic objectForKey:@"vip"];
	self.stamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	//	self.ext = [dic objectForKey:@"ext"];
}

@end
