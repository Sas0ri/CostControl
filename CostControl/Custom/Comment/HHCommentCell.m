//
//  HHCommentCell.m
//  Huhoo
//
//  Created by Jason Chong on 13-1-20.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHCommentCell.h"
#import "HHUtils.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"

#define kCommentCellMinHeight    80
#define kCommentCotentWidth  242
#define kCommentContentMaxHeight 9999
#define kCommentContentFont  [UIFont systemFontOfSize:14.0f]
#define kCommentContentMinHeight 18

@implementation HHCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {

	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setComment:(HHComment*)comment
{
    _comment = comment;
    [self.avatarImageView setImageWithURL:comment.avatarUrl placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    if (_comment.workerName.length <= 0) {
        _comment.workerName = @"未知";
    }
    if (_comment.dept.length > 0) {
        self.authorLabel.text = [NSString stringWithFormat:@"[%@] %@", _comment.dept, _comment.workerName];
    }
    else
    {
        self.authorLabel.text = _comment.workerName;
    }
    self.authorLabel.text = [self.authorLabel.text stringByAppendingFormat:@"	%@", comment.result];
    
	self.timeLabel.text = comment.time;
    self.contentLabel.text = comment.content;
    
    [self updateSubViewsFrame];
}

- (void)setModel:(NSDictionary *)model
{
	[self updateSubViewsFrame];
}

- (void)updateSubViewsFrame
{
    CGRect frame = self.authorLabel.frame;
	frame.size.width = 240;
    self.authorLabel.frame = frame;
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    frame = self.contentLabel.frame;
    frame.size.height = [HHCommentCell contentHeight:self.contentLabel.text];
    self.contentLabel.frame = frame;
	
	frame = self.timeLabel.frame;
    CGFloat textWidth = [self.timeLabel.text sizeWithFont:self.timeLabel.font constrainedToSize:CGSizeMake(240, self.timeLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping].width+2;
    frame.size.width = textWidth;
	frame.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 10;
    self.timeLabel.frame = frame;
}


+ (CGFloat)cellHeight:(HHComment *)comment
{
    if (comment == nil) {
        return kCommentCellMinHeight;
    }
    CGFloat contentHeight = [HHCommentCell contentHeight:comment.content];
    contentHeight += kCommentCellMinHeight - kCommentContentMinHeight+12;
    if (contentHeight < kCommentCellMinHeight) {
        contentHeight = kCommentCellMinHeight;
    }
    return contentHeight;
}

+ (CGFloat)contentHeight:(NSString *)text
{
    if (text.length == 0) {
        return kCommentContentMinHeight;
    }
    CGFloat height = [text sizeWithFont:kCommentContentFont constrainedToSize:CGSizeMake(kCommentCotentWidth, kCommentContentMaxHeight) lineBreakMode:NSLineBreakByWordWrapping].height;
    return height;
}

@end

@implementation HHSepLine

- (void)layoutSubviews
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctx, 0, 0);
	CGContextAddLineToPoint(ctx, rect.size.width, 0);
	CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"d3d3d3"].CGColor);
	CGContextSetLineWidth(ctx, rect.size.height/2);
	CGContextClosePath(ctx);
	CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, 0, rect.size.height/2);
	CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height /2);
	CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"f9f9f9"].CGColor);
	CGContextClosePath(ctx);
	CGContextStrokePath(ctx);
}

@end