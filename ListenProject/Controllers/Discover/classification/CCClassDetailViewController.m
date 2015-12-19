//
//  CCClassDetailViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCClassDetailViewController.h"
#import "CCGlobalHeader.h"
#import "CCTitleLabel.h"
#import "CCClassDetailTableViewController.h"
#import "CCAlbumDetailViewController.h"
#import "CCPlayerBtn.h"
#import "CCClassMoreMsgViewController.h"

@interface CCClassDetailViewController ()<UIScrollViewDelegate,CCClassDetailTableViewControllerDelegate,CCClassMoreMsgViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) UIView * redView;
@property (nonatomic, strong) CCClassDetailTableViewController * vc;

@property (nonatomic, strong) CCClassMoreMsgViewController * more;

@end

@implementation CCClassDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.cateTitle;
    [self createTopScrollView];
}
- (void)createTopScrollView {
    self.scrollView.showsHorizontalScrollIndicator = NO;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/tagsWithoutCover?categoryId=%ld&contentType=album&device=android", self.categoryId];
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"list"];
        
        for (NSDictionary * sdict in array) {
            [self.titleArray addObject:sdict];
        }
        
        for (NSInteger i = 0; i < self.titleArray.count; i++) {
            CCTitleLabel * titleLabel = [[CCTitleLabel alloc] initWithFrame:CGRectMake(i*SCREEN_SIZE.width/5, 0, SCREEN_SIZE.width/5, 23)];
            titleLabel.text = self.titleArray[i][@"tname"];
            titleLabel.indext = i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.userInteractionEnabled = YES;
            [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
            [self.scrollView addSubview:titleLabel];
        }
        
        CGFloat contentX = self.titleArray.count * SCREEN_SIZE.width/5;
        self.scrollView.tag = 40;
        self.scrollView.contentSize = CGSizeMake(contentX, 25);
        self.scrollView.bounces= NO;
        
        [self createBottomScrollView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, SCREEN_SIZE.width/5, 2)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.redView];
    
}
- (void)createBottomScrollView {
    
    CGFloat contentX = self.titleArray.count * SCREEN_SIZE.width;
    
    self.bottonScrollView.contentSize = CGSizeMake(contentX, self.bottonScrollView.frame.size.height);
    self.bottonScrollView.tag = 30;
    self.bottonScrollView.delegate = self;
    self.bottonScrollView.showsHorizontalScrollIndicator = NO;
    self.bottonScrollView.showsVerticalScrollIndicator = NO;
    self.bottonScrollView.pagingEnabled = YES;
    self.bottonScrollView.bounces = NO;
    
    
    self.vc = [[CCClassDetailTableViewController alloc] init];
    self.vc.delegate = self;
    self.vc.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.bottonScrollView.frame.size.height);
    self.vc.cateData = self.titleArray[0];
    self.vc.categoryId = [self.titleArray[0][@"category_id"] integerValue];
    
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
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
    self.vc.cateData = self.titleArray[index];
    self.vc.categoryId = [self.titleArray[index][@"category_id"] integerValue];
    [self.vc.dataSource removeAllObjects];
    self.vc.view.frame = CGRectMake(index * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, self.bottonScrollView.frame.size.height);
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];

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


- (IBAction)moreBtnDidClicked:(id)sender {
    
    
    self.more = [[CCClassMoreMsgViewController alloc] initWithNibName:@"CCClassMoreMsgViewController" bundle:nil];
    self.more.dataSource = [[NSMutableArray alloc] init];
    self.more.dataSource = self.titleArray;
    
    self.more.delegate = self;
    [self addChildViewController:self.more];
    [self.view addSubview:self.more.view];

    self.more.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    //创建动画
    CATransition * ca = [CATransition animation];
    //设置动画的格式
    ca.type = @"kCATransitionFade";
    //设置动画的方向
    ca.subtype = @"fromTop";
    //设置动画的持续时间
    ca.duration = 1;
    [self.more.view.superview.layer addAnimation:ca forKey:nil];

    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.hidden  = YES;
}

- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    //让滑动条的位置随着title的点击而改变
    CCTitleLabel *titlelable = (CCTitleLabel *)recognizer.view;
    [UIView animateWithDuration:0.25 animations:^{
        self.redView.frame = CGRectMake(titlelable.indext * self.scrollView.frame.size.width/4, 23, self.scrollView.frame.size.width/4, 2);
    }];
    
    //设置view随着title点击而改变
    CGFloat offsetX = titlelable.indext * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.bottonScrollView setContentOffset:offset animated:YES];
}

- (void)pushToAlbumVCWithAlbumId:(NSInteger)albumId
{
    CCAlbumDetailViewController * album = [[CCAlbumDetailViewController alloc] initWithNibName:@"CCAlbumDetailViewController" bundle:nil];
    album.hidesBottomBarWhenPushed = YES;
    album.index = albumId;
    [self.navigationController pushViewController:album animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - moreMsgViewControllerDelegate

- (void)hiddenMsgView
{
    [self.more.view removeFromSuperview];
}

- (void)reloadDataWithCategory:(NSInteger)cate andPaiXu:(NSInteger)paixu
{
    
    // 添加控制器
    self.vc.cateData = self.titleArray[cate];
    self.vc.categoryId = [self.titleArray[cate][@"category_id"] integerValue];
    [self.vc.dataSource removeAllObjects];
    self.vc.view.frame = CGRectMake(cate * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, self.bottonScrollView.frame.size.height);
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    [self.vc relodaDataWithDataWithPaixu:paixu];
    
    
    
    CGFloat offsetX = cate * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.bottonScrollView setContentOffset:offset animated:YES];
}

- (NSMutableArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

@end
