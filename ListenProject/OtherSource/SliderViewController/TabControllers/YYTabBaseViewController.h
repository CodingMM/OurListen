//
//  YYTabBaseViewController.h
//  TPSApp
//
//  Created by xiating on 15/6/4.
//  Copyright (c) 2015年 YY. All rights reserved.
//
#import "QHBasicViewController.h"
/********* Tabar 界面的Controller的基类 *********/

/*
#import "ParallaxHeader.h"
#import "UITableView+ParallaxHeader.h"
*/
#define FountMax 19
#define FountMin 14

#define MaxMoveY 78 * SCREEN_SIZE.height/568

#define ColorTopR 234
#define ColorBottomR 236

#define ColorTopB 66
#define ColorBottomB 81

#define titleLMinY 27

#define titleLMaxY 83


#define iconMaxY 115 * SCREEN_SIZE.height/568

#define iconMinY 23.5

#define iconMaxWidth 55 * SCREEN_SIZE.height/568

#define iconMinWidth 36 * SCREEN_SIZE.height/568

#define btnMaxWidth 25
#define btnMinWidth 20

#define iconMaxX SCREEN_SIZE.width - 70
#define iconMinX SCREEN_SIZE.width - 130
#define TabarHeight 49


@interface YYTabBaseViewController : UIViewController

@property (nonatomic, retain) UIImageView *navBackground;
@property (nonatomic, retain) UILabel *titleL;

-(void)enterMessageVC:(id)sender;

@end
