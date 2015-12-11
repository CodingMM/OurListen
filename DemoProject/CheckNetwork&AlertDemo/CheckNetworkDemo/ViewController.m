//
//  ViewController.m
//  CheckNetworkDemo
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    NSArray * array = @[@"正在提交", @"关闭提示", @"提示成功并自动关闭", @"提示失败并自动关闭", @"提示成功", @"提示失败"];
    
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(30 + 190*j , 60 + 60*i , 180, 30)];
            
            btn.backgroundColor = [UIColor blackColor];
            
            btn.tag = 100 + i*2 + j;
            
            [btn setTitle:array[i*2 + j] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.view addSubview:btn];
            
            
            
        }
    }
    
    
   
}

- (void)btnClick:(id)sender{

    UIButton * btn = (UIButton *)sender;
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    
    if (btn.tag == 100) {
     
        [appDelegate showLoading:@"正在请求"];
        
        
    }
    
    if (btn.tag == 101) {
     
        [appDelegate hideLoading];
    }
    
    if (btn.tag == 102) {
        
        [appDelegate hideLoadingWithSuc:@"请求成功后隐藏之前的提示框" WithInterval:1.5];
    }
    
    if (btn.tag == 103) {
     
        [appDelegate hideLoadingWithSuc:@"请求失败后隐藏之前的提示框" WithInterval:1.5];
        
    }
    
    if (btn.tag == 104) {
        
        [appDelegate showSucMsg:@"请求数据成功!" WithInterval:1.5f];    }
    
    if (btn.tag == 105) {
        
        [appDelegate showErrMsg:@"请求数据失败!" WithInterval:1.5f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
