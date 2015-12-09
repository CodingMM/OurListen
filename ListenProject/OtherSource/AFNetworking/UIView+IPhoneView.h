//
//  UIView+IPhoneView.h
//  SaveMachine
//
//  Created by Elean on 15/10/14.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GT_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
#define GT_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#define STATUS_BAR_OFFSET ( GT_IOS7 ? 20.0 : 0.0)

#define GT_IOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6
#define GT_IOS5 [[[UIDevice currentDevice] systemVersion] floatValue] >= 5


@interface UIView (IPhoneView)
-(void) fixYForIPhone5:(BOOL) isFixY addHight:(BOOL) isAddHight;
-(void)fixIOS7;

-(void)addTapAction:(SEL)action forTarget:(id) aTarget;

- (void) exaggerationBorderWidth:(CGFloat)borderWidth radius:(CGFloat)radius color:(CGColorRef)color;

- (void) exaggerationShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(CGColorRef)color ;
@end
