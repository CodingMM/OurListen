//
//  ScannerDetailController.m
//  ScannerDemo
//
//  Created by Elean on 15/12/8.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import "ScannerDetailController.h"
#import "ELNLabel.h"
#import "NSString+category.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.hright

@interface ScannerDetailController ()
@property (nonatomic,strong) ELNLabel * codeLabel;
@end

@implementation ScannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:238/255.0 blue:218/255.0 alpha:1];
    [self prepareView];
    
    
   }

#pragma mark -- 创建视图
- (void)prepareView{
//topView
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    
    topView.backgroundColor = [UIColor colorWithRed:230/255.0 green:82/255.0 blue:84/255.0 alpha:1];
    
    [self.view addSubview:topView];
    
//titleLabel
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W - 150)*0.5, 30, 150, 30)];
    
    lblTitle.textAlignment =NSTextAlignmentCenter;
    
    lblTitle.text = @"扫描结果";
    
    lblTitle.font = [UIFont systemFontOfSize:25.0f];
    
    lblTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:lblTitle];
    
//返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 33)];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_white.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
//codeLabel
    _codeLabel = [[ELNLabel alloc]initWithFrame:CGRectMake(50, 150, SCREEN_W - 100 , 200)];
    _codeLabel.backgroundColor = [UIColor whiteColor];
    
    _codeLabel.layer.masksToBounds = YES;
    
    _codeLabel.layer.borderWidth = 1;
    
    _codeLabel.layer.borderColor = topView.backgroundColor.CGColor;
    
    _codeLabel.textStr = self.scannerValueStr;
    
    [_codeLabel setNeedsDisplay];
    
    _codeLabel.userInteractionEnabled = YES;
    
    [self.view addSubview:_codeLabel];
    
//tap
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCodeLabel:)];
    
    [_codeLabel addGestureRecognizer:longPress];
    
    
    
}

#pragma mark -- 手势
- (void)longPressCodeLabel:(UILongPressGestureRecognizer *)longPress{

    //跳转Safari浏览器
    
    if(longPress.state == UIGestureRecognizerStateBegan){
    
        _codeLabel.color = [UIColor lightGrayColor];
        [_codeLabel setNeedsDisplay];
        
    }
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        _codeLabel.color = [UIColor blueColor];
        [_codeLabel setNeedsDisplay];
        if ([_scannerValueStr trim]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_scannerValueStr]];
        }
        
    }
    
    
}

#pragma mark -- 返回事件
- (void)backClick:(id)sender{

    [self.navigationController popToRootViewControllerAnimated:YES];
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
