//
//  CCLiveDetailViewController3.m
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCLiveDetailViewController3.h"
#import "CCPlayerViewController.h"
#import "CCPlayerBtn.h"
#import "CCLiveCell2.h"

@interface CCLiveDetailViewController3 ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation CCLiveDetailViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCLiveCell2" bundle:nil] forCellReuseIdentifier:CCLISTENCell2ID];
    
   [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    [self downloadData];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self downloadData];
    }];
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateTriggered];
    
    [self.tableView.pullToRefreshView setTitle:@"正在努力加载..." forState:SVPullToRefreshStateLoading];
    
    [self.tableView.pullToRefreshView setTitle:@"刷新完成" forState:SVPullToRefreshStateStopped];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // NSLog(@"加载更多");
        [self loadmoreData];
    }];
}

- (void)downloadData
{
    
    
    self.currentPageNum = 1;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getRadiosListByType?provinceCode=%@&pageSize=15&pageNum=%ld&device=android&radioType=2", self.provinceId,self.currentPageNum];
    
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.dataSource removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"result"];
        
        self.dataSource = (NSMutableArray *)array;
        
        [self.tableView.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)loadmoreData
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getRadiosListByType?provinceCode=%@&pageSize=15&pageNum=%ld&device=android&radioType=2", self.provinceId,self.currentPageNum+1];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"result"];
        
        for (NSDictionary * dict in array) {
            [self.dataSource addObject:dict];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.tableView reloadData];
        self.currentPageNum++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITalbelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCLiveCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell2ID forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    [cell.jiemuImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverSmall"]]];
    cell.titleLabel.text = dict[@"rname"];
    cell.detailLabel.text = dict[@"programName"];
    
    NSInteger i = [dict[@"radioPlayCount"] integerValue];
    if (i > 10000) {
        cell.numberLabel.text = [NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
    }else {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld", i];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    player.radioData = dict;
    player.type = 2;
    player.programId = 3;
    
    [self presentViewController:player animated:YES completion:^{
        CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
        playerBtn.hidden = YES;
        [player createAudioPlayer];
    }];

}
#pragma mark -  懒加载
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
