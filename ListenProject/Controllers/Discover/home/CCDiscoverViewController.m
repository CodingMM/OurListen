//
//  CCDiscoverViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/9.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCDiscoverViewController.h"
#import "CCGlobalHeader.h"
#import "CCTitleLabel.h"
#import "CCRecomViewController.h"
#import "CCClassViewController.h"
#import "CCLiveTableViewController.h"
#import "CCSearchViewController.h"
#import "CCAddMoreViewController.h"

@interface CCDiscoverViewController ()<CCRecomViewControllerDelegate>
@property (nonatomic, retain) UIView *topView;//分栏标题的底视图
@property (nonatomic, retain) UIView *redView;
@property (nonatomic, retain) UIScrollView *scrollView;//标题的滚动视图

@end

@implementation CCDiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航条
    [self navigationItemSetting];
    [self createTitleView];

    [self createScrollView];

}

#pragma mark - 设置导航条

-(void)navigationItemSetting
{
    
   
    
    self.navigationItem.title = @"随便听听";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(searchBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_search_n"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];

    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showLeftVC)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
   
    
}
-(void)showLeftVC
{
    
    
    CCAddMoreViewController *addMoreView = [[CCAddMoreViewController alloc]init];
    
     addMoreView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addMoreView animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
/**
 *  创建分栏标题
 */
-(void)createTitleView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_SIZE.width, 40)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"findtab" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    for (NSInteger i = 0; i < 3; i++) {
        
        CCTitleLabel * titleLabel = [[CCTitleLabel alloc] initWithFrame:CGRectMake(i * SCREEN_SIZE.width / 3, 0, SCREEN_SIZE.width / 3, 37)];
        titleLabel.text = array[i][@"title"];
        titleLabel.indext = i;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTaped:)]];
        
        [self.topView addSubview:titleLabel];
    }
    CCTitleLabel *lable = [self.topView.subviews firstObject];
    lable.scale = 1.0;
    
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, SCREEN_SIZE.width/3, 3)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.topView addSubview:self.redView];
}
/**
 *  创建滚动视图
 */
-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, SCREEN_SIZE.height - 40)];
    //添加视图控制器的view
    [self addController];
    CGFloat contentX = self.childViewControllers.count * SCREEN_SIZE.width;
    
    self.scrollView.contentSize = CGSizeMake(contentX, self.scrollView.frame.size.height);
    self.scrollView.tag = 30;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    UIViewController * vc = [self.childViewControllers firstObject];
    vc.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 113);
    [self.scrollView addSubview:vc.view];
    [self.view addSubview:self.scrollView];
}

#pragma mark - 添加滚动视图的子view
-(void)addController
{
    CCRecomViewController * reVC =[[CCRecomViewController alloc] initWithNibName:@"CCRecomViewController" bundle:nil];
    reVC.delegate = self;
    reVC.index = 0;
    [self addChildViewController:reVC];
    
    CCClassViewController * categoryVC = [[CCClassViewController alloc] initWithNibName:@"CCClassViewController" bundle:nil];
    categoryVC.index = 1;
    [self addChildViewController:categoryVC];
    
    CCLiveTableViewController * liveVC = [[CCLiveTableViewController alloc] initWithNibName:@"CCLiveTableViewController" bundle:nil];
    liveVC.index = 2;
    [self addChildViewController:liveVC];
}


#pragma mark - 搜索按钮被点击
-(void)searchBtnDidClicked:(UIButton *)sender
{
    CCSearchViewController * searchVC = [[CCSearchViewController alloc] initWithNibName:@"CCSearchViewController" bundle:nil];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 分页标题被点击
-(void)titleTaped:(UITapGestureRecognizer *)gesture
{
    CCTitleLabel *titlelable = (CCTitleLabel *)gesture.view;
    
    //设置view随着title点击而改变
    CGFloat offsetX = titlelable.indext * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];;
}



#pragma mark - CCRecomViewControllerDelegate Method
/**
 *滚动推荐的视图控制器的滚动协议方法
 */
- (void)setScrollViewContentOffSet:(CGPoint)index
{
    [self.scrollView setContentOffset:index animated:YES];
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    self.redView.frame = CGRectMake(value*SCREEN_SIZE.width/3, 37, SCREEN_SIZE.width/3, 3);
    
    
    NSUInteger leftIndex = (int)value;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    CCTitleLabel *labelLeft = self.topView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
}


//停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    // 添加控制器
    CCRecomViewController *newsVc = self.childViewControllers[index];
    
    for (NSInteger i = 0; i < 3; i++) {
        if (i != index) {
            CCTitleLabel * le = self.topView.subviews[i];
            le.scale = 0.0;
        }
    }
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = CGRectMake(index * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height - 113);
    [self.scrollView addSubview:newsVc.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
