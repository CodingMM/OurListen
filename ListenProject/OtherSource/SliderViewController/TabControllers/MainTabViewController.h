//
//  MainTabViewController.h
//  TPSApp
//
//  Created by xiating on 15/6/2.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "QHBasicViewController.h"

@interface MainTabViewController : QHBasicViewController

+ (MainTabViewController *)getMain;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end
