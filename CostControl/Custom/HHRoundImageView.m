//
//  HHRoundImageView.m
//  Huhoo
//
//  Created by Sasori on 13-4-25.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHRoundImageView.h"
#import "objc/runtime.h"

static char operationKey;

@interface HHRoundImageView()
- (void)tapAction:(id)sender;
- (void)commonInit;
@end

@implementation HHRoundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	self.backgroundColor = [UIColor clearColor];
	_radius = self.frame.size.width/2;
	
	UITapGestureRecognizer* tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	tg.numberOfTapsRequired = 1;
	tg.numberOfTouchesRequired = 1;
	[self addGestureRecognizer:tg];
	self.userInteractionEnabled = YES;
}

- (void)tapAction:(id)sender
{
	[self.delegate didTapOnView:self];
}

- (void)setRadius:(CGFloat)radius
{
	_radius = radius;
	[self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_radius].CGPath;
	CGContextAddPath(ctx, clippath);
	CGContextClip(ctx);
	[self.image drawInRect:self.bounds];
	CGContextRestoreGState(ctx);
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;
{
    if ([self.imageUrl.absoluteString isEqualToString:url.absoluteString]) {
        return;
    }
    [self cancelCurrentImageLoad];
	self.imageUrl = url;
    self.image = placeholder;
    
    if (url)
    {
        __weak HHRoundImageView *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
			__strong HHRoundImageView *sself = wself;
			if (!sself) {
				return;
			}
			if (image)
			{
				sself.image = image;
			}
			if (completedBlock && finished)
			{
				completedBlock(image, error, cacheType);
			}
		}];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
