//
//  HEBubbleViewItem.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HEBubbleViewItem;
@protocol HEBubbleViewItemDelegate <NSObject>

-(void)selectedBubbleItem:(HEBubbleViewItem *)item; 


@end

@interface HEBubbleViewItem : UIView

@property (nonatomic, strong) id<HEBubbleViewItemDelegate> delegate;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, assign) BOOL highlightTouches;

@property (nonatomic, retain) UIColor *unselectedBGColor;
@property (nonatomic, retain) UIColor *selectedBGColor;

@property (nonatomic, retain) UIColor *unselectedBorderColor;
@property (nonatomic, retain) UIColor *selectedBorderColor;

@property (nonatomic, retain) UIColor *unselectedTextColor;
@property (nonatomic, retain) UIColor *selectedTextColor;

@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat bubbleTextLabelPadding;
@property (nonatomic, assign) CGPoint touchBegan;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifierIN;
-(void)setBubbleItemIndex:(NSInteger)itemIndex;

-(void)prepareItemForReuse;


@end
