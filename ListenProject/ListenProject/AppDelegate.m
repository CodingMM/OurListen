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
//拖拽返回
#import "UIViewController+MLTransition.h"
#import "CCGlobalHeader.h"

//极光推送
#import "APService.h"

//第三方分享

//第三方平台的SDK头文件，根据需要的平台导入。
//以下分别对应微信、新浪微博、腾讯微博、人人、易信
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
//开启QQ和Facebook网页授权需要
#import <QZoneConnection/ISSQZoneApp.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    [self createTabBarController];
    //添加极光推送
    [self addJpushService:launchOptions];
    
    
    
    [ShareSDK registerApp:@"7e4b6816d820"];
    [self initializePlat];
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];

    
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


#pragma mark - 第三方分享

-(void)initializePlat
{
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           wechatCls:[WXApi class]];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //QQ
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //豆瓣
    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
                            appSecret:@"9f1e7b4f71304f2f"
                          redirectUri:@"http://www.sharesdk.cn"];
    //Instagram
    [ShareSDK connectInstagramWithClientId:@"ff68e3216b4f4f989121aa1c2962d058"
                              clientSecret:@"1b2e82f110264869b3505c3fe34e31a1"
                               redirectUri:@"http://sharesdk.cn"];
    //印象笔记
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - ---------------


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
