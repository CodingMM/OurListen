//
//  AppDelegate.h
//  CheckNetworkDemo
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//提示网络状态（不带block）
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer;

//提示网络状态（带block）
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response;

//提示正在提交
-(void)showLoading:(NSString *)msg;

//关闭提示
-(void)hideLoading;

//提示成功信息 并在几秒后自动关闭
-(void)hideLoadingWithSuc:(NSString *)msg WithInterval:(float)timer;

//提示错误信息 并在几秒后自动关闭
-(void)hideLoadingWithErr:(NSString *)msg WithInterval:(float)timer;

//提示成功
-(void)showSucMsg:(NSString *)msg WithInterval:(float)timer;

//提示失败
-(void)showErrMsg:(NSString *)msg WithInterval:(float)timer;

//提示网络错误
- (void)showNetworkError;




@end

