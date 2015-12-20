//
//  CCPlayerViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCPlayerViewController.h"
#import "CCPlayerHeadViewController.h"
#import "CCPlayerBtn.h"
#import "CCGlobalHeader.h"
#import "CCPlayerCommentCell.h"
#import "CCAlbumDetailViewController.h"
#import "CCSegmentedView.h"
#import "CCPlayerDetailViewController.h"
#import "CCPlayerCommonTableViewController.h"
#import "CCDownloadManager.h"
#import "CCHistoryViewController.h"
#import "CCPlayerRecomTableViewController.h"

BOOL isHistoryShowed = NO;

@interface CCPlayerViewController ()<UIScrollViewDelegate,CCSegmentedViewDelegate,PlayerRecomendDelegate,CCPlayerHeadViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property (nonatomic, strong) CCPlayerHeadViewController * head;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) CCSegmentedView * sege;

@property (nonatomic, strong) UIScrollView * bottomScroll;

@property (nonatomic, strong) CCPlayerDetailViewController * vc1;
@property (nonatomic, strong) CCPlayerCommonTableViewController * vc2;
@property (nonatomic, strong) CCPlayerRecomTableViewController * vc3;

@property (nonatomic, strong) UIView * alertView;

@property (nonatomic, strong) CCHistoryViewController * history;


@end


@implementation CCPlayerViewController
- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"histroy" object:nil];
}

+(CCPlayerViewController *)sharePlayerViewController
{
    static CCPlayerViewController * vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[CCPlayerViewController alloc] initWithNibName:@"CCPlayerViewController" bundle:nil];
    });
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.topScrollView.contentOffset = CGPointMake(0, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstPlay = 0;
    
    if (self.type == 2) {
        [self createAudioPlayer];
    }
    
    [self createScrollView];
    
    [self setupUI];
    
    [self registerNotification];
}
- (void)registerNotification {
    //增加观察者，
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:@"history" object:nil];
}

- (void)notifi:(NSNotification *)notifi {
    if (isHistoryShowed == YES) {
        [self.history.view removeFromSuperview];
        self.topScrollView.scrollEnabled = YES;
        isHistoryShowed = NO;
    }
    
    NSDictionary * dict = notifi.userInfo[@"data"];
    NSInteger trackId = [dict[@"trackId"] integerValue];
    NSInteger comment = [dict[@"comments"] integerValue];
    self.trackId = trackId;
    
    self.name = dict[@"title"];
    self.commentNum = comment;
    
    [self createPlayer];
    [self reloadData];
    
}


- (void)createAudioPlayer {
    
    self.isFirstPlay = 1;
    
    self.topScrollView.scrollEnabled = NO;
    
    self.head = [CCPlayerHeadViewController sharedPlayerHeadViewController];
    
    if (self.programId == 2) {
        [self.head downloadDataWithAudioId2:self.audioId];
    }else if (self.programId == 3) {
        [self.head downloadDataWithRadioData:self.radioData];
    }else {
        [self.head downloadDataWithAudioId:self.audioId];
    }
    
    self.head.view.frame = CGRectMake(0, 20, SCREEN_SIZE.width, SCREEN_SIZE.height - 69);
    [self.view addSubview:self.head.view];
    
}


- (void)createScrollView {
    
    self.topScrollView.tag = 30;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.pagingEnabled = NO;
    self.topScrollView.bounces = NO;
    self.topScrollView.delegate = self;
    
    [self addController];
    CGFloat contentX = self.childViewControllers.count * SCREEN_SIZE.width;
    
    self.bottomScroll = [[UIScrollView alloc] init];
    self.bottomScroll.pagingEnabled = YES;
    self.bottomScroll.bounces = NO;
    self.bottomScroll.tag = 40;
    self.bottomScroll.showsHorizontalScrollIndicator = NO;
    self.bottomScroll.frame = CGRectMake(0, SCREEN_SIZE.width - 19, SCREEN_SIZE.width, 370);
    self.bottomScroll.contentSize = CGSizeMake(contentX, self.bottomScroll.frame.size.height);
    self.bottomScroll.backgroundColor = [UIColor purpleColor];
    self.bottomScroll.delegate = self;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i*self.bottomScroll.frame.size.width, 0, self.bottomScroll.frame.size.width, self.bottomScroll.frame.size.height);
        [self.bottomScroll addSubview:vc.view];
    }
    [self.topScrollView addSubview:self.bottomScroll];
    self.topScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height-19+self.bottomScroll.frame.size.height);
}

- (void)addController {
    self.vc1 = [[CCPlayerDetailViewController alloc] init];
    [self addChildViewController:self.vc1];
    
    self.vc2 = [[CCPlayerCommonTableViewController alloc] init];
    [self addChildViewController:self.vc2];
    
    self.vc3 = [[CCPlayerRecomTableViewController alloc] init];
    self.vc3.delegate = self;
    [self addChildViewController:self.vc3];
}


- (void)createPlayer {
    
    self.topScrollView.scrollEnabled = YES;
    self.sege = [[CCSegmentedView alloc] init];
    self.sege.frame = CGRectMake(0, SCREEN_SIZE.height - 69, SCREEN_SIZE.width, 50);
    self.sege.delegate = self;
    [self.sege.sege setTitle:[NSString stringWithFormat:@"评论（%ld）",self.commentNum] forSegmentAtIndex:1];
    [self.topScrollView addSubview:self.sege];
    
    
    self.isFirstPlay = 1;
    
    self.bottomScroll.contentOffset = CGPointMake(0, 0);
    
    [self.sege.sege setTitle:[NSString stringWithFormat:@"评论（%ld）",self.commentNum] forSegmentAtIndex:1];
    
    self.head = [CCPlayerHeadViewController sharedPlayerHeadViewController];
    self.head.delegate = self;
    self.head.songList = self.songList;
    
    NSString * title = self.name;
    NSString * path1 = NSHomeDirectory();
    NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
    path1 = [path1 stringByAppendingPathComponent:str];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path1]) {
        [self.head createDataWithPath:path1 andTrackId:self.trackId];
    }else {
        [self.head downloadDataWithTrackId:self.trackId];
    }
    
    self.head.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 69);
    [self.topScrollView addSubview:self.head.view];
    
}

- (void)setupUI {
    
    
    [self.downloadBtn setImage:[UIImage imageNamed:@"np_toolbar_donwload_n"] forState:UIControlStateNormal];
    
    [self.shareBtn setImage:[UIImage imageNamed:@"np_toolbar_share_n"] forState:UIControlStateNormal];
    
    
    [self.downloadBtn setImage:[UIImage imageNamed:@"np_toolbar_donwload_h"] forState:UIControlStateSelected];
    [self.downloadBtn addTarget:self action:@selector(downloadBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setImage:[UIImage imageNamed:@"np_toolbar_share_h"] forState:UIControlStateSelected];
    [self.shareBtn addTarget:self action:@selector(shareBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)shareBtnDidClicked:(UIButton *)btn {
    
    /*
    [UMSocialSnsService presentSnsController:self appKey:@"562e28cb67e58e9d2c001f8b" shareText:@"随心所欲，聆听我心" shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline,UMShareToRenren] delegate:self];
     */
    
}


- (void)downloadBtnDidClicked:(UIButton *)btn {
    
    if (self.type == 2) {
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(100, 550, 140, 50)];
        self.alertView.alpha = 0.7;
        self.alertView.backgroundColor = [UIColor blackColor];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
        label.text = @"该资源不支持下载";
        label.layer.cornerRadius = 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self.alertView addSubview:label];
        [self.view addSubview:self.alertView];
        
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1];
        return;
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [[defaults objectForKey:CURRENT_SONGNUMBER] integerValue];
    NSDictionary * dict = self.songList[num];
    NSInteger trackid = [dict[@"trackId"] integerValue];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/track/detail?trackId=%ld", trackid];
    
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString * path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        if (dict == nil) {
            dict = [[NSMutableDictionary alloc] init];
            NSMutableArray * array1 = [[NSMutableArray alloc] init];
            [dict setObject:array1 forKey:@"正在下载"];
            
            NSMutableArray * array2 = [[NSMutableArray alloc] init];
            [dict setObject:array2 forKey:@"下载完成"];
            
            [dict writeToFile:path atomically:YES];
        }
        
        NSMutableArray * array = dict[@"正在下载"];
        NSMutableArray * array2 = dict[@"下载完成"];
        
        for (NSDictionary * dic in array) {
            if (dic[@"trackId"] == json[@"trackId"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不允许重复下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return ;
            }
        }
        
        for (NSDictionary * dic in array2) {
            if (dic[@"trackId"] == json[@"trackId"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不允许重复下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return ;
            }
        }
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(100, 550, 140, 50)];
        self.alertView.alpha = 0.7;
        self.alertView.backgroundColor = [UIColor blackColor];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
        label.text = @"已加入下载队列";
        label.layer.cornerRadius = 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self.alertView addSubview:label];
        [self.view addSubview:self.alertView];
        
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1];
        
        [CCDownloadManager downloadDataWithUrl:json[@"downloadUrl"] andTitle:json[@"title"]];
        
        [array addObject:json];
        [dict setObject:array forKey:@"正在下载"];
        [dict writeToFile:path atomically:YES];
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"shuaxin" object:nil];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)removeAlertView {
    [self.alertView removeFromSuperview];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 30) {
        if (scrollView.contentOffset.y <= 370) {
            self.bottomScroll.scrollEnabled = NO;
        }else {
            self.bottomScroll.scrollEnabled = YES;
        }
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 40) {
        NSUInteger index = scrollView.contentOffset.x / self.bottomScroll.frame.size.width;
        self.sege.sege.selectedSegmentIndex = index;
    }
}

#pragma mark - segementViewDelegate

- (void)setBottomScrollViewContentOffSetWithIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.bottomScroll.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.bottomScroll setContentOffset:offset animated:YES];
}

#pragma mark - playerRecomendDelegate

// 为了从相关推荐里跳转到新的专辑时，专辑页面刷新数据
- (void)reloadDataWithAlbumId:(NSInteger)albumId
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadDataWithPlayerAlbumId:)]) {
        [_delegate reloadDataWithPlayerAlbumId:albumId];
    }
}


- (void)reloadDataWithTrackId:(NSInteger)trackid andCommentNum:(NSInteger)num
{
    self.trackId = trackid;
    [self reloadData];
    [self.sege.sege setTitle:[NSString stringWithFormat:@"评论（%ld）",num] forSegmentAtIndex:1];
}


- (void)reloaddataWithCommentNum:(NSInteger)num andTrackID:(NSInteger)trackid {
    
    [self.vc1 downloadDataWithTrackId:trackid];
    [self.vc2 downloadDataWithTrackId:trackid];
    [self.vc3 downloadDataWithTrackId:trackid];
    
    [self.sege.sege setTitle:[NSString stringWithFormat:@"评论（%ld）",num] forSegmentAtIndex:1];
}

- (void)createHistoryView
{
    if (isHistoryShowed == NO) {
        self.history = [[CCHistoryViewController alloc] initWithNibName:@"CCHistoryViewController" bundle:nil];
        self.history.view.frame = CGRectMake(20, 64+10, SCREEN_SIZE.width - 40, SCREEN_SIZE.height - 350);
        [self.view addSubview:self.history.view];
        self.topScrollView.scrollEnabled = NO;
        isHistoryShowed = YES;
    }else {
        [self.history.view removeFromSuperview];
        self.topScrollView.scrollEnabled = YES;
        isHistoryShowed = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isHistoryShowed == YES) {
        [self.history.view removeFromSuperview];
        self.topScrollView.scrollEnabled = YES;
        isHistoryShowed = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)reloadData {
    [self.vc1 downloadDataWithTrackId:self.trackId];
    [self.vc2 downloadDataWithTrackId:self.trackId];
    [self.vc3 downloadDataWithTrackId:self.trackId];
}

@end
