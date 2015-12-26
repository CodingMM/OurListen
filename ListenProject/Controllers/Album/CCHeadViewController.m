//
//  CCHeadViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCHeadViewController.h"
#import "UIImageView+WebCache.h"
#import "CCGlobalHeader.h"
@interface CCHeadViewController ()

@end

@implementation CCHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, -20,SCREEN_SIZE.width , 20)];
    statusView.backgroundColor = STATUS_COLOR;
    [self.view addSubview:statusView];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidDisappear:(BOOL)animated{

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewDidDisappear:animated];
}

- (IBAction)backBtnDidClicked:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(popBeforeViewController)]) {
        [_delegate popBeforeViewController];
    }
    
}


- (void)reloadDataWithDictory:(NSDictionary *)dict
{
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dict[@"coverOrigin"]] placeholderImage:[UIImage alloc]];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverLarge"]] placeholderImage:[UIImage alloc]];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dict[@"avatarPath"]] placeholderImage:[UIImage alloc]];
    self.imageView2.layer.cornerRadius = 15;
    self.imageView2.clipsToBounds = YES;
    self.topTitleLabel.text = dict[@"title"];
    self.titleLabel.text = dict[@"nickname"];
    self.detailLabel.text = dict[@"intro"];
    
    NSInteger i = [dict[@"playTimes"] integerValue];
    if (i > 10000) {
        self.numberLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
    }else {
        self.numberLabel.text =[NSString stringWithFormat:@"%ld", i];
    }
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
