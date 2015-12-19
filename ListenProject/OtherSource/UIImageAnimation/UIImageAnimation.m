//
//  UIImageAnimation.m
//  MyUility
//
//  Created by qianfeng on 14-10-12.
//  Copyright (c) 2014年 haisheng. All rights reserved.
//

#import "UIImageAnimation.h"

@implementation UIImageAnimation
//time 几秒内完成这个动画
+(CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画
{
    //提供了对单一动画的实现
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;//1e100f
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
//repeatTimes 重复的次数 time动画持续的时间
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; //有闪烁次数的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.4];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    return  animation;
}
//time 动画持续的时间
//问题一 x是横向移动的距离吗 为啥它不变呢
+(CABasicAnimation *)moveXWithTime:(float)time X:(NSNumber *)x //横向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    [animation setFromValue:[NSNumber numberWithInt:0]];
    animation.toValue=x;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y //纵向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue=y;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
//Multiple 放大的倍数
//最小的倍数
//time 持续的时间
//repeatTimes 重复的次数
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes //缩放
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=orginMultiple;
    animation.toValue=Multiple;
    animation.duration=time;
    animation.autoreverses=YES;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}


+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes //路径动画
{
    //CAKeyframeAnimation关键帧动画，可以定义行动的路线
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //path demo1 4个角移动
//    CGMutablePathRef path =CGPathCreateMutable();
//    CGPathMoveToPoint(path,NULL,0, 64);
//    CGPathAddLineToPoint(path,NULL, 320, 64);
//    CGPathAddLineToPoint(path, NULL, 0, 480);
//    CGPathAddLineToPoint(path, NULL, 320, 480);
//    CGPathAddLineToPoint(path,NULL, 40, 40);
//    CGPathCloseSubpath(path);
    
   //圆
   // CGPathAddArc(path, NULL, 100, 100, 100, 0, 6.28, NO);
   
    
    
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    return animation;
}
//移动的是偏移量
+(CABasicAnimation *)movepoint:(CGPoint )point //点移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.toValue=[NSValue valueWithCGPoint:point];
    animation.removedOnCompletion=NO;
    animation.duration = 1;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
//dur 时间 direction方向 
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount //旋转
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);//; 第一个参数是旋转角度，后面三个参数形成一个围绕其旋转的向量，起点位置由UIView的center属性标识。
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    
    return animation;
}
+(CABasicAnimation *)rock{
    CABasicAnimation *theAnimation1;    //定义动画
    
    //左右摇摆
    theAnimation1=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    theAnimation1.fromValue=[NSNumber numberWithFloat:0];
    theAnimation1.toValue=[NSNumber numberWithFloat:-100];
    
    theAnimation1.duration=5.5;//动画持续时间
    theAnimation1.repeatCount=6;//动画重复次数
    theAnimation1.autoreverses=YES;//是否自动重复
    return theAnimation1;
}
//左右摇晃,图标的抖动
+(CAAnimation * )shakeAnimation {
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];//指定动画的属性
    [animation setDuration:1];//调整动画的持续时间
    [animation setRepeatCount:10000];
    // Try to get the animationto begin to start with a small offset
    // that makes it shake out of sync withother layers. srand([[NSDate date] timeIntervalSince1970]);
    float rand = (float)random();
    [animation setBeginTime:CACurrentMediaTime() + rand * .0000000001];
    NSMutableArray *values =[NSMutableArray array]; // Turn right
    [values addObject:DegreesToNumber(-10)]; // Turn left
    [values addObject:DegreesToNumber(10)]; // Turn right
    [values addObject:DegreesToNumber(-10)]; // Set the values for the animation
    
    //第一帧转10个度数到右边，第二帧转10个度数到左边，然后第三帧再转两个度数到右边。当动画完成时，它再次启动然后通过调用setRepeatCount:10000来重复10000次。视觉上就是在中轴上不停的抖动。要停止动画，可以通过调用-removeAnimationForKey:@”rotate”这个函数从层上面移除动画
    
    [animation setValues:values];
    return animation;
}
NSNumber*DegreesToNumber(CGFloat degrees) {
    return [NSNumber numberWithFloat:DegreesToRadians(degrees)];
}
//DegreesToNumber使用一个CGFloat值作为参数，然后返回一个NSNumber把度数转化成弧度，通过调用函数DegreesToRadians
CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;}

//注意一：一个视图的layer添加动画后，必须移除动画后对视图的frame操作才会有效
//注意二：如何快速获得视图在屏幕上的相对坐标

/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}
@end
