//
//  RootViewController.m
//  ScannerDemo
//
//  Created by Elean on 15/12/8.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import "RootViewController.h"
#import "ScannerViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 175, 150, 50)];
    
    [btn setTitle:@"进入二维码扫描" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:btn];
    
}

#pragma mark -- 模态视图弹出二维码扫描界面

- (void)btnClick:(id)sender{
    

    ScannerViewController * scannerView = [[ScannerViewController alloc]init];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:scannerView];
    
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
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
