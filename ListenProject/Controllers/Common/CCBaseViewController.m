//
//  CCBaseViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/9.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppDelegate];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationItemSetting];
}
-(void)navigationItemSetting
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:222/255.0f green:88/255.0f blue:45/255.0f alpha:1];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)setUpAppDelegate{

     self.appDelegate = [UIApplication sharedApplication].delegate;
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
