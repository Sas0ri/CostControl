//
//  HHApprovalItem.m
//  Huhoo
//
//  Created by Jason Chong on 13-4-19.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHApprovalItem.h"
#import "HHUtils.h"

@implementation HHApprovalItem

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.data = data;
        self.sqId = [HHUtils numberIdFromJsonId:[data objectForKey:@"sq_id"]];
        self.chkId = [HHUtils numberIdFromJsonId:[data objectForKey:@"fl_id"]];
        self.ccId = [HHUtils numberIdFromJsonId:[data objectForKey:@"cc_id"]];
        self.primaryDate = [HHUtils dateFromString:[data objectForKey:@"fl_beign_time"]];
		self.updateTime = [HHUtils dateFromString:data[@"fl_update_time"]];
        self.sqName = [data objectForKey:@"fl_formtype"];
        self.workerId = [HHUtils numberIdFromJsonId:[data objectForKey:@"fl_wid"]];
        self.deptId = [HHUtils numberIdFromJsonId:[data objectForKey:@"dept_id"]];
        self.copId = [HHUtils numberIdFromJsonId:[data objectForKey:@"fl_cid"]];
		self.status = [self statusFromString:data[@"fl_result"]];
        self.workerName = [data objectForKey:@"fl_wid_name"];
		self.fcId = [HHUtils numberIdFromJsonId:data[@"fc_id"]];
		self.fdId = [HHUtils numberIdFromJsonId:data[@"fd_id"]];
		self.summary = data[@"fl_tips"];
		
		NSString* fdTag = data[@"fd_tag"];
		if ([fdTag isKindOfClass:[NSString class]]) {
			self.isHurry = [fdTag rangeOfString:@"urgent"].location != NSNotFound;
			self.isBack = [fdTag rangeOfString:@"back"].location != NSNotFound;
			self.isReminded = [fdTag rangeOfString:@"major"].location != NSNotFound;
		}
        if ([data objectForKey:@"fl_wid_dept"] && [[data objectForKey:@"fl_wid_dept"] isKindOfClass:[NSString class]]) {
            self.deptName = [data objectForKey:@"fl_wid_dept"];
        }
        else
        {
            self.deptName = @"部门";
        }
        
        if ([data objectForKey:@"fl_wid_headpic"] && [[data objectForKey:@"fl_wid_headpic"] isKindOfClass:[NSString class]]) {
            self.avatarUrl = [NSURL URLWithString:[HHUtils avatarUrlString:[data objectForKey:@"fl_wid_headpic"]]];
        }
        else
        {
            self.avatarUrl = nil;
        }
    }
    return self;
}

- (NSNumber*)statusFromString:(NSString*)string
{
	NSNumber* ret = @(-1);
	if ([string isEqualToString:@"agree"]) {
		ret = @(3);
	}
	if ([string isEqualToString:@"disagree"]) {
		ret = @(2);
	}
	if ([string isEqualToString:@"wait"]) {
		ret = @(1);
	}
	if ([string isEqualToString:@"back"]) {
		ret = @(0);
	}
	return ret;
}

- (BOOL)isEqualToApprovalItem:(HHApprovalItem *)anotherApprovalItem
{
    if (![self.copId isEqualToNumber:anotherApprovalItem.copId]) {
        return NO;
    }
    if (![self.deptId isEqualToNumber:anotherApprovalItem.deptId]) {
        return NO;
    }
    if (![self.workerId isEqualToNumber:anotherApprovalItem.workerId]) {
        return NO;
    }
    if (![self.sqId isEqualToNumber:anotherApprovalItem.sqId]) {
        return NO;
    }
    if (self.chkId && anotherApprovalItem.chkId && [self.chkId isEqualToNumber:anotherApprovalItem.chkId]) {
        return YES;
    }
    if (!self.chkId && !anotherApprovalItem.chkId) {
        return YES;
    }
    return NO;
}

@end
