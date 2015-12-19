//
//  UIImageAnimation.h
//  MyUility
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 haisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface UIImageAnimation : NSObject
+(CABasicAnimation *)opacityForever_Animation:(float)time; //永久闪烁的动画
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; //有闪烁次数的动画
+(CABasicAnimation *)moveXWithTime:(float)time X:(NSNumber *)x ; //横向移动
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y; //纵向移动
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes; //缩放

+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes; //路径动画
+(CABasicAnimation *)movepoint:(CGPoint )point; //点移动
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount; //旋转
+(CABasicAnimation *)rock;//摇晃
+(CAAnimation * )shakeAnimation;//抖动效果
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;//快速获得视图相对屏幕的坐标
@end
