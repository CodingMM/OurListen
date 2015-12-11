//
//  AppDelegate.m
//  CheckNetworkDemo
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AJNotificationView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self monitorNetworkStatus];
    //循环检测网络
    
    return YES;
}

#pragma mark - 循环检测网络连接状态

-(void)monitorNetworkStatus
{
    //1. 创建对象 通过不断的去请求百度的地址来检测网络状态
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    //2. 注册通知 监听网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    //3. 开始监听 如果网络状态发生变化 则触发通知方法
    [reach startNotifier];
   
    
}

#pragma mark -- 网络状态改变触发的通知方法
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Notification Says Reachable");
    }
    else
    {
        NSLog(@"Notification Says Unreachable");
        [self showNoticeMsg:@"无网络连接，请检查网络" WithInterval:2.0f];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 全局提示信息

//提示网络状态（不带block）
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:timer
                                response:^{
                                    // NSLog(@"Response block");
                                }];
}
//提示网络状态（带block）
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:timer offset:0.0f delay:0.0f detailDisclosure:YES
                                response:response];
}

//提示正在提交
-(void)showLoading:(NSString *)msg
{
    NSString *content;
    
    if (msg==nil) {
        content=@"正在提交数据，请稍后…"; //正在提交数据，请稍后…
    }
    else
    {
        content=msg;
    }
    
    [SVProgressHUD showWithStatus:content maskType:SVProgressHUDMaskTypeClear];
}

//关闭提示
-(void)hideLoading
{
    [SVProgressHUD dismiss];
}

//提示成功信息 并在几秒后自动关闭
-(void)hideLoadingWithSuc:(NSString *)msg WithInterval:(float)timer
{
    [SVProgressHUD dismissWithSuccess:msg afterDelay:timer];
}

//提示错误信息 并在几秒后自动关闭
-(void)hideLoadingWithErr:(NSString *)msg WithInterval:(float)timer
{
    [SVProgressHUD dismissWithError:msg afterDelay:timer];
}

//提示成功
-(void)showSucMsg:(NSString *)msg WithInterval:(float)timer
{
    NSString *content;
    
    if (msg==nil) {
        content=@"成功"; //成功
    }
    else
    {
        content=msg;
    }
    
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:content afterDelay:timer];
}

//提示失败
-(void)showErrMsg:(NSString *)msg WithInterval:(float)timer
{
    NSString *content = nil;
    
    if (msg==nil) {
        content = @"失败";  //失败
    }
    else
    {
        content = msg;
    }
    
    [SVProgressHUD show];
    [SVProgressHUD dismissWithError:content afterDelay:timer];
}

//提示网络错误
- (void)showNetworkError
{
    [SVProgressHUD show];
    [SVProgressHUD dismissWithError:@"网络错误" afterDelay:1.5];
}



@end
