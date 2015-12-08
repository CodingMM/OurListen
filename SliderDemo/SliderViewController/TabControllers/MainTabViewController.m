//
//  MainTabViewController.m
//  TPSApp
//
//  Created by xiating on 15/6/2.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "MainTabViewController.h"

/*
#import "YYPlanListViewController.h"
#import "YYReimHomeController.h"
#import "YYAuditListViewController.h"
#import "YYTicketQueryViewController.h"
#import "YYMySelfViewController.h"
#import "YYNewReimHomeController.h"
#import "YYMySelfViewController.h"
*/
@interface MainTabViewController (){
    
}
@end

@implementation MainTabViewController
static MainTabViewController *main;
+ (MainTabViewController *)getMain
{
    return main;
}

- (id)init{
    self = [super init];
    main = self;
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    
    _tabBarController = [[UITabBarController alloc]init];
    _tabBarController.tabBar.hidden = YES;
    
    if ([_tabBarController.viewControllers count]) {
        _tabBarController.viewControllers = nil;
    }
    _tabBarController.selectedIndex = 0;
#pragma mark - 把主界面方法这个地方官
    /*
    YYPlanListViewController *plan = [[YYPlanListViewController alloc]init];
    YYNewReimHomeController *submit = [[YYNewReimHomeController alloc]init];
    YYTicketQueryViewController *bookTicket = [[YYTicketQueryViewController alloc]init];
    bookTicket.style = TabBarStyle;
    YYAuditListViewController *audit = [[YYAuditListViewController alloc]init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:plan,bookTicket,submit,audit, nil];

    _tabBarController.viewControllers = viewControllers;
    [_tabBarController.view setFrame:self.view.frame];
     */
    [self.view addSubview:_tabBarController.view];

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
