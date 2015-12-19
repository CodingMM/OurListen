//
//  CCLiveDetailViewController2.m
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCLiveDetailViewController2.h"
#import "CCGlobalHeader.h"
#import "CCPlayerViewController.h"
#import "CCTitleLabel.h"
#import "CCPlayerBtn.h"
#import "CCLiveDetailViewController3.h"
#import "CCPlayerBtn.h"
#import "CCLiveMoreViewController.h"

@interface CCLiveDetailViewController2 ()<UIScrollViewDelegate,CCLiveMoreViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottonScrollView;

@property (nonatomic, assign) NSInteger currentPageNum;

@property (nonatomic, strong) UIView * redView;
@property (nonatomic, strong) NSArray * titleArray;


@property (nonatomic, strong) CCLiveDetailViewController3 * vc;

@property (nonatomic, strong) CCLiveMoreViewController * more;

@end

@implementation CCLiveDetailViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.titleLabel.text = self.topTitle;
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.hidden = NO;
}

- (void)createScrollView {
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * array = dict[@"list"];
    
    self.titleArray = array;
    
    for (NSInteger i = 0; i < array.count; i++) {
        CCTitleLabel * titleLabel = [[CCTitleLabel alloc] initWithFrame:CGRectMake(i*SCREEN_SIZE.width/5, 0, SCREEN_SIZE.width/5, 23)];
        titleLabel.text = array[i][@"name"];
        titleLabel.indext = i;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
        [self.scrollView addSubview:titleLabel];
    }
    
    CGFloat contentX = array.count * SCREEN_SIZE.width/5;
    self.scrollView.tag = 40;
    self.scrollView.contentSize = CGSizeMake(contentX, 25);
    self.scrollView.bounces= NO;
    
    [self createBottomScrollView];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, SCREEN_SIZE.width/5, 2)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.redView];
}

- (void)createBottomScrollView {

    CGFloat contentX = self.titleArray.count * SCREEN_SIZE.width;
    
    self.bottonScrollView.contentSize = CGSizeMake(contentX, SCREEN_SIZE.height - 97);
    self.bottonScrollView.tag = 30;
    self.bottonScrollView.delegate = self;
    self.bottonScrollView.showsHorizontalScrollIndicator = NO;
    self.bottonScrollView.showsVerticalScrollIndicator = NO;
    self.bottonScrollView.pagingEnabled = YES;
    self.bottonScrollView.bounces = NO;
    
    
    self.vc = [[CCLiveDetailViewController3 alloc] initWithNibName:@"CCLiveDetailViewController3" bundle:nil];

    self.vc.provinceId = self.titleArray[0][@"provinceId"];
    self.vc.view.frame = CGRectMake(0, 0, self.bottonScrollView.frame.size.width, SCREEN_SIZE.height - 97);
    
    
    [SVProgressHUD showWithStatus:@"加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    [self.vc downloadData];
    [self.bottonScrollView addSubview:self.vc.view];
    
}

#pragma mark - delegate
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / SCREEN_SIZE.width;
    
    CCTitleLabel *titleLable = (CCTitleLabel *)self.scrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.scrollView.frame.size.width * 0.1;
    CGFloat offsetMax = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    //创建动画
    CATransition * ca = [CATransition animation];
    //设置动画的格式
    ca.type = @"rippleEffect";
    //设置动画的方向
    ca.subtype = @"fromRight";
    //设置动画的持续时间
    ca.duration = 2;
    [scrollView.superview.layer addAnimation:ca forKey:nil];
    
    CGPoint offset = CGPointMake(offsetx, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
    
    // 添加控制器
    self.vc.provinceId = self.titleArray[index][@"provinceId"];
    self.vc.view.frame = CGRectMake(index * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 97);
    
     [SVProgressHUD showWithStatus:@"加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    [self.vc.dataSource removeAllObjects];
    [self.vc downloadData];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.redView.frame = CGRectMake(value * SCREEN_SIZE.width/5, 23, SCREEN_SIZE.width/5, 2);
    }];
    
}

- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    //让滑动条的位置随着title的点击而改变
    CCTitleLabel *titlelable = (CCTitleLabel *)recognizer.view;

    [UIView animateWithDuration:0.25 animations:^{
        self.redView.frame = CGRectMake(titlelable.indext * SCREEN_SIZE.width/5, 23, SCREEN_SIZE.width/5, 2);
    }];
    
    //设置view随着title点击而改变
    CGFloat offsetX = titlelable.indext * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.bottonScrollView setContentOffset:offset animated:YES];
}



#pragma mark - btnDidClicked
- (IBAction)moreBtnDidClicked:(id)sender {
    
    
    self.more = [[CCLiveMoreViewController alloc] initWithNibName:@"CCLiveMoreViewController" bundle:nil];
    self.more.delegate = self;
    [self addChildViewController:self.more];
    [self.view addSubview:self.more.view];
    
    self.more.view.frame = CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 350);
    //创建动画
    CATransition * ca = [CATransition animation];
    //设置动画的格式
    ca.type = @"rippleEffect";
    //设置动画的方向
    ca.subtype = @"fromTop";
    //设置动画的持续时间
    ca.duration = 1.5;
    [self.more.view.superview.layer addAnimation:ca forKey:nil];
    
}
- (IBAction)backBtnDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - moreMCollectionViewDelegate
- (void)hiddenMsgView
{
    [self.more.view removeFromSuperview];
}

- (void)reloadDataWithProvinceId:(NSInteger)provinceId
{
    // 添加控制器
    self.vc.provinceId = self.titleArray[provinceId][@"provinceId"];

    [self.vc.dataSource removeAllObjects];
    self.vc.view.frame = CGRectMake(provinceId * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, self.bottonScrollView.frame.size.height);
    
    [SVProgressHUD showWithStatus:@"加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];

    [self.vc downloadData];

    CGFloat offsetX = provinceId * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.bottonScrollView setContentOffset:offset animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
