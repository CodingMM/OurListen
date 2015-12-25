//
//  CCAlbumDetailViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCAlbumDetailViewController.h"
#import "CCHeadViewController.h"
#import "CCAlbumCell.h"
#import "CCGlobalHeader.h"
#import "CCPlayerViewController.h"
#import "CCMethod.h"
#import "AFHTTPSessionManager.h"
#import "CCPlayerBtn.h"

BOOL isSelected = NO;
@interface CCAlbumDetailViewController ()<CCBackBtnDelegate,CCPlayerViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;//管理数据源的数组

@property (nonatomic, strong) CCHeadViewController * headVC;
@property (nonatomic, assign) NSInteger  num;
@property (nonatomic, assign) NSInteger  playNum;

@property (nonatomic, strong) AFHTTPSessionManager * manager;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UIView * selectView;

@end

@implementation CCAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /*
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y -= 64;
    
   [self.progressHUD showInRect:rect inView:self.view animated:YES];
     
     */
    
    [SVProgressHUD showWithStatus:@"加载数据" maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    [self downloadDataWithAlbumId:self.index];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.hidden = NO;
    
}

#pragma mark - Helper Methods

- (void)createTableView {
    
    self.tableView.bounces = NO;
    self.tableView.tableHeaderView = self.view2;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCAlbumCell" bundle:nil] forCellReuseIdentifier:CCAlbumCellID];
    __weak CCAlbumDetailViewController *weekSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weekSelf loadmoreData];
    }];
    
}

- (void)downloadDataWithAlbumId:(NSInteger)albumId {
    
    self.currentPage = 1;
    
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/%ld/20?albumId=%ld&pageSize=20&isAsc=true&position=2", albumId, self.currentPage, albumId];
    
    [self.manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.dataSource removeAllObjects];
        
        NSDictionary * dict = json[@"album"];
        self.headVC = [[CCHeadViewController alloc] init];
        self.tableView.tableHeaderView = self.headVC.view;
        self.headVC.delegate = self;
        [self.headVC reloadDataWithDictory:dict];
        
        
        
        self.num = [dict[@"tracks"] integerValue];
        
        NSArray * array = json[@"tracks"][@"list"];
        for (NSDictionary * dict in array) {
            [self.dataSource addObject:dict];
        }
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

// 加载更多的数据
- (void)loadmoreData
{
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/%ld/20?albumId=%ld&pageSize=20&isAsc=true&position=2", self.index, self.currentPage + 1, self.index];
    
    [self.manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = json[@"tracks"][@"list"];
        for (NSDictionary * dict in array) {
            [self.dataSource addObject:dict];
        }
        
        // 停掉加载更多的动画
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        
        // 数据加载完成之后，让当前页加1
        self.currentPage++;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = self.dataSource[indexPath.row][@"title"];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(300, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat h = rect.size.height + 40;
    return h;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CCAlbumCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    NSInteger i = [dict[@"playtimes"] integerValue];
    if (i > 10000) {
        cell.playNumberLabel.text = [NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
    }else {
        cell.playNumberLabel.text = [NSString stringWithFormat:@"%ld", i];
    }
    
    NSInteger time1 = [dict[@"duration"]integerValue];
    cell.timeLengthLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time1/60, time1%60];
    
    NSInteger time = [dict[@"createdAt"]integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    cell.timeLabel.text = [CCMethod passedTimeSince:date];
    
    
    cell.chatNumberLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"comments"] integerValue]];
    
    cell.titleLabel.text = dict[@"title"];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    imageView2.image = [UIImage imageNamed:@"bg_statusbar"];
    [self.view2 addSubview:imageView2];
    
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 10)];
    numberLabel.font = [UIFont systemFontOfSize:10];
    numberLabel.textColor = [UIColor grayColor];
    numberLabel.text = [NSString stringWithFormat:@"共%ld集", self.num];
    [self.view2 addSubview:numberLabel];
    
    
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(kScreenWidth - 60, 10, 50, 10);
    //    [button setImage:[UIImage imageNamed:@"album_segButton"] forState:UIControlStateNormal];
    //    [button setTitle:@"选集" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(selectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    //    button.titleLabel.font = [UIFont systemFontOfSize:10];
    //    [self.view2 addSubview:button];
    return self.view2;
}


- (void)selectBtnDidClicked:(UIButton *)btn
{
    if (isSelected == NO) {
        
        
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.tableView rectForHeaderInSection:0].origin.y+50, SCREEN_SIZE.width, 0)];
        self.selectView.backgroundColor = [UIColor blackColor];
        self.selectView.alpha = 0.5;
        [self.view addSubview:self.selectView];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.selectView.frame = CGRectMake(0, [self.tableView rectForHeaderInSection:0].origin.y+50, SCREEN_SIZE.width, self.tableView.frame.size.height);
        }];
        self.tableView.scrollEnabled = NO;
        isSelected = YES;
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.selectView.frame = CGRectMake(0, [self.tableView rectForHeaderInSection:0].origin.y+50, SCREEN_SIZE.width, 0);
        }];
        [self performSelector:@selector(removeHistory) withObject:self afterDelay:0.5];
        
        self.tableView.scrollEnabled = YES;
        isSelected = NO;
    }
}
- (void)removeHistory
{
    [self.selectView removeFromSuperview];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    NSInteger trackId = [dict[@"trackId"] integerValue];
    NSInteger comment = [dict[@"comments"] integerValue];
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    player.delegate = self;
    player.trackId = trackId;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger number = indexPath.row;
    [defaults setObject:@(number) forKey:CURRENT_SONGNUMBER];
    NSMutableArray * array = self.dataSource;
    [defaults setObject:array forKey:@"songlist"];
    [defaults setObject:@(trackId) forKey:@"trackid"];
    [defaults setObject:@(comment) forKey:@"comment"];
    [defaults setObject:dict[@"title"] forKey:@"title"];
    [defaults synchronize];
    
    player.name = dict[@"title"];
    player.commentNum = comment;
    player.songList = self.dataSource;
    
    [self presentViewController:player animated:YES completion:^{

        
        CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
        playerBtn.hidden = YES;
        
        
        [player createPlayer];
        [player reloadData];
    }];
}


#pragma  mark - backBtnDelegate

- (void)popBeforeViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reloadDataWithPlayerAlbumId:(NSInteger)albumId
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadDataWithAlbumId:)]) {
        [_delegate reloadDataWithAlbumId:albumId];
    }
}




- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
