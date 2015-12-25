//
//  AppDelegate.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/8.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "AppDelegate.h"

#import "AJNotificationView.h"
#import "SVProgressHUD.h"

#import "CCTabBarController.h"
#import "CCPlayerViewController.h"
#import "CCPlayerBtn.h"

#import "UIViewController+MLTransition.h"
#import "CCGlobalHeader.h"
#import "APService.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    [self createTabBarController];
    [self addJpushService:launchOptions];
    return YES;
}
#pragma mark -  创建滑动视图作为根视图
-(void)createTabBarController
{
    CCTabBarController *tab = [CCTabBarController shareTabBarController];
    
    /*******拖拽返回*******/
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    self.window.rootViewController = tab;
    /*创建播放按钮*/
    [self createPlayerBtn];

    
}

#pragma mark - 创建播放按钮
- (void)createPlayerBtn
{
    
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    [playerBtn addTarget:self action:@selector(playerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:playerBtn];

}
/**
 *  播放按钮点击事件
 */
-(void)playerBtnClicked:(CCPlayerBtn *)sender
{
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    [self.window.rootViewController presentViewController:player animated:YES completion:^{
        CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
        playerBtn.hidden = YES;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        if (player.isFirstPlay == 0) {
            // 根据NSUserDefaults里存储的信息，初始化播放器
            
            NSString * title = [defaults objectForKey:@"title"];
            NSInteger track = [[defaults objectForKey:@"trackid"] integerValue];
            NSInteger comment = [[defaults objectForKey:@"comment"] integerValue];
            NSMutableArray * array = [defaults objectForKey:@"songlist"];
            player.songList = array;
            player.trackId = track;
            player.name = title;
            [player createPlayer];
            [player reloaddataWithCommentNum:comment andTrackID:track];
        }
        
    }];

}


#pragma mark - 消息推送

-(void)addJpushService:(NSDictionary *)launchOptions
{
   
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)categories:nil];
    }
#else
        
    [APService
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)  categories:nil];
#endif
        
     [APService handleRemoteNotification:launchOptions];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 将deviceToken发送给极光
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理接收的消息,回调极光
    [APService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //支持iOS 7必须实现
    [APService handleRemoteNotification:userInfo];
}

#pragma mark - -----------------

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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

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
