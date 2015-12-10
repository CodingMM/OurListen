//
//  CCTabBarController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/9.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCTabBarController.h"
#import "CCDiscoverViewController.h"
#import "CCPlayerViewController.h"
#import "CCDownloadViewController.h"
#import "CCNavigationController.h"

@interface CCTabBarController ()



@end


@implementation CCTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self tabBarSetting];
    
}
#pragma mark - 设置tabBar

-(void)tabBarSetting
{
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"bg_statusbar"];
    
    NSArray * tabbarNArray = @[@"tabbar_find_n", @"tabbar_download_n"];
    NSArray * tabbarHArray = @[@"tabbar_find_h", @"tabbar_download_h"];
    
    NSArray * vcClass = @[[CCDiscoverViewController class],  [CCDownloadViewController class]];
    
    NSMutableArray * vcs = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIViewController * vc = [[vcClass[i] alloc] init];
        CCNavigationController * naV = [[CCNavigationController alloc] initWithRootViewController:vc];
        UIImage * tabImg = [[UIImage imageNamed:tabbarNArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedImg = [[UIImage imageNamed:tabbarHArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        naV.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:tabImg selectedImage:selectedImg];
        if (i == 0) {
            naV.tabBarItem.imageInsets = UIEdgeInsetsMake(5, -15, -5, 15);
        }else {
            naV.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 15, -5, -15);
        }
        
        
        [vcs addObject:naV];
    }
    
    self.viewControllers = vcs;
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
