//
//  SliderViewControllerHeader.h
//  OurListen
//
//  Created by 夏婷 on 15/12/8.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#ifndef OurListen_SliderViewControllerHeader_h
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()

#define RELOADIMAGE @"reloadImage"

#define FountName @"Helvetica Neue"
#define BoldName @"Helvetica-Bold"//加粗
#define HEITI @"STHeitiK-Light"//黑体亮


#define OurListen_SliderViewControllerHeader_h


#endif
