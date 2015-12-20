//
//  CCDownloadViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCDownloadViewController.h"
#import "CCGlobalHeader.h"
#import "CCPlayerBtn.h"
#import "CCTitleLabel.h"
#import "CCRecomViewController.h"
#import "CCAlbumDetailViewController.h"
#import "CCSoundViewController.h"
#import "CCDownloadTaskViewController.h"
#include <sys/param.h>
#include <sys/mount.h>

@interface CCDownloadViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *RAMLabel;

@property (nonatomic, strong) UIView * redView;
@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation CCDownloadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    CCPlayerBtn *palyerBtn = [CCPlayerBtn sharePlayerBtn];
    palyerBtn.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTopView];
    [self createScrollView];
    [self createRAMLabel];
}

- (void)createRAMLabel
{
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict1[@"下载完成"];
    NSInteger size = 0;
    
    for (NSDictionary * dic in array) {
        size = size + [dic[@"downloadSize"]integerValue];
    }
    
    if (size > 1024*1024*1024) {
        NSString * str1 = [NSString stringWithFormat:@"%.2lfMB", (CGFloat)size/1024/1024];
        NSString * str2 = [self freeDiskSpaceInBytes];
        self.RAMLabel.text = [NSString stringWithFormat:@"已占用%@，%@", str1, str2];
    }else {
        NSString * str1 = [NSString stringWithFormat:@"%.2lfMB", (CGFloat)size/1024/1024];
        NSString * str2 = [self freeDiskSpaceInBytes];
        self.RAMLabel.text = [NSString stringWithFormat:@"已占用%@，%@", str1, str2];
    }
}

- (NSString *)freeDiskSpaceInBytes {
    struct statfs buf;
    float freespace = -1;
    if (statfs("/var", &buf) >= 0) {
        freespace = (float)(buf.f_bsize * buf.f_bfree);
    }
    if (freespace > 1024*1024*1024) {
        return [NSString stringWithFormat:@"手机剩余存储空间为：%0.2fGB",freespace/1024/1024/1024];
    }
    return [NSString stringWithFormat:@"手机剩余存储空间为：%0.1fMB",freespace/1024/1024];
}


- (void)createTopView {
    
    NSArray * array = @[@"专辑", @"声音", @"下载中"];
    for (NSInteger i = 0; i < 3; i++) {
        
        CCTitleLabel * titleLabel = [[CCTitleLabel alloc] initWithFrame:CGRectMake(i * SCREEN_SIZE.width / 3, 0, SCREEN_SIZE.width / 3, 41)];
        titleLabel.text = array[i];
        titleLabel.indext = i;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
        
        [self.topView addSubview:titleLabel];
    }
    CCTitleLabel *lable = [self.topView.subviews firstObject];
    lable.scale = 1.0;
    
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_SIZE.width/3, 3)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.topView addSubview:self.redView];
    
}

- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    //让滑动条的位置随着title的点击而改变
    CCTitleLabel *titlelable = (CCTitleLabel *)recognizer.view;
    
    //设置view随着title点击而改变
    CGFloat offsetX = titlelable.indext * SCREEN_SIZE.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)createScrollView {
    
    [self addController];
    CGFloat contentX = self.childViewControllers.count * SCREEN_SIZE.width;
    
    self.scrollView.contentSize = CGSizeMake(contentX, self.scrollView.frame.size.height-50);
    self.scrollView.tag = 30;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    
    UIViewController * vc = [self.childViewControllers firstObject];
    vc.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vc.view];
    
    [self.view addSubview:self.scrollView];
}

- (void)addController {
    
    CCAlbumDetailViewController * myVC =[[CCAlbumDetailViewController alloc] initWithNibName:@"CCAlbumDetailViewController" bundle:nil];
    myVC.index = 0;
    [self addChildViewController:myVC];
    
    CCSoundViewController * myVC2 =[[CCSoundViewController alloc] initWithNibName:@"CCSoundViewController" bundle:nil];
    myVC2.index = 1;
    [self addChildViewController:myVC2];
    
    CCDownloadTaskViewController * myVC3 =[[CCDownloadTaskViewController alloc] initWithNibName:@"CCDownloadTaskViewController" bundle:nil];
    myVC3.index = 2;
    [self addChildViewController:myVC3];
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
    NSUInteger index = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    // 添加控制器
    UITableViewController *newsVc = self.childViewControllers[index];
    
    for (NSInteger i = 0; i < 3; i++) {
        if (i != index) {
            CCTitleLabel * le = self.topView.subviews[i];
            le.scale = 0.0;
        }
    }
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = CGRectMake(index * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [self.scrollView addSubview:newsVc.view];
    
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    self.redView.frame = CGRectMake(value*SCREEN_SIZE.width/3, 41, SCREEN_SIZE.width/3, 3);
    
    
    NSUInteger leftIndex = (int)value;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    CCTitleLabel *labelLeft = self.topView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
}


#pragma mark - 懒加载

- (NSMutableArray * )dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
