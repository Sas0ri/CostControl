//
//  HHTouchView.h
//  Huhoo
//
//  Created by Sasori on 13-4-2.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHTouchViewDelegate <NSObject>
-(void)didTouchInView:(id)sender;
@end

@interface HHTouchView : UIView
@property (nonatomic, weak) id<HHTouchViewDelegate> delegate;
@end
