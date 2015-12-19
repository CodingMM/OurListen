//
//  CCClassDetailTableViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCClassDetailTableViewController.h"
#import "CCGlobalHeader.h"
#import "CCClassRecomCell.h"

@interface CCClassDetailTableViewController ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CCClassDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"CCClassRecomCell" bundle:nil] forCellReuseIdentifier:CCCLASSRECOMCellID];

    // 下拉刷新
    __weak CCClassDetailTableViewController * weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf downloadData];
    }];
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateTriggered];
    
    [self.tableView.pullToRefreshView setTitle:@"正在努力加载..." forState:SVPullToRefreshStateLoading];
    
    [self.tableView.pullToRefreshView setTitle:@"刷新完成" forState:SVPullToRefreshStateStopped];
    
    
    // 上拉加载
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadmoreData];
    }];
}

- (void)downloadData
{

    self.currentPage = 1;
    NSString * str = self.cateData[@"tname"];
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%ld&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", self.categoryId,self.currentPage, encodingString];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"list"];
        [self.dataSource addObjectsFromArray:array];
        // 让下拉刷新的控件停掉
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
    
    NSString * str = self.cateData[@"tname"];
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%ld&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", self.categoryId,self.currentPage + 1, encodingString];
    
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = json[@"list"];
        for (NSDictionary  *dict in array) {
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

- (void)relodaDataWithDataWithPaixu:(NSInteger)paixu
{
    [self.dataSource removeAllObjects];
    
    NSArray * array = @[@"hot", @"recent", @"classic"];
    
    NSString * calc = array[paixu];
    
    self.currentPage = 1;
    NSString * str = self.cateData[@"tname"];
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlStr = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=%@&categoryId=%ld&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", calc, self.categoryId,self.currentPage, encodingString];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"list"];
        for (NSDictionary  *dict in array) {
            [self.dataSource addObject:dict];
        }
        // 让下拉刷新的控件停掉
        [self.tableView.pullToRefreshView stopAnimating];
        
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCClassRecomCell *cell = [tableView dequeueReusableCellWithIdentifier:CCCLASSRECOMCellID forIndexPath:indexPath];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"albumCoverUrl290"]]];
    cell.albumDetailLabel.text = dict[@"intro"];
    cell.albumTitle.text = dict[@"title"];
    
    NSInteger i = [dict[@"playsCounts"] integerValue];
    
    if (i > 10000) {
        cell.numberLabel.text = [NSString stringWithFormat:@"%.2lf万", (CGFloat)i/10000];
    }else {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld", i];
    }
    cell.countLabel.text = [NSString stringWithFormat:@"%ld集", [dict[@"tracks"] integerValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    NSInteger albumId = [dict[@"albumId"] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(pushToAlbumVCWithAlbumId:)]) {
        [self.delegate pushToAlbumVCWithAlbumId:albumId];
    }
    
}



    
#pragma mark - 懒加载

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}



@end
