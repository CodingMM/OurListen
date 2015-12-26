//
//  CCLiveDetailViewController3.m
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCLiveDetailViewController3.h"
#import "CCPlayerViewController.h"
#import "AppDelegate.h"
#import "CCPlayerBtn.h"
#import "CCLiveCell2.h"
#import "DataAPI.h"

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
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate showLoading:@"正在加载数据..."];
    
    [DataAPI getProvinceRadionWithPageNum:self.currentPageNum andCode:self.provinceId  andSuccessBlock:^(NSURL *url, id data) {
        [self.dataSource removeAllObjects];
        
        NSDictionary *dict = (NSDictionary *)data;
        
        NSArray * array = dict[@"result"];
        
        self.dataSource = (NSMutableArray *)array;
        
        [self.tableView.pullToRefreshView stopAnimating];
        [appDelegate hideLoading];
        
        [self.tableView reloadData];
    } andFailBlock:^(NSURL *url, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
   }

- (void)loadmoreData
{
   
    
    [DataAPI getProvinceRadionWithPageNum:self.currentPageNum+1 andCode:self.provinceId  andSuccessBlock:^(NSURL *url, id data) {
        [self.dataSource removeAllObjects];
        
        NSDictionary *dict = (NSDictionary *)data;
        
        NSArray * array = dict[@"result"];
        
        self.dataSource = (NSMutableArray *)array;
        
        [self.tableView.pullToRefreshView stopAnimating];
        
        self.currentPageNum++;
        
        
        [self.tableView reloadData];
    } andFailBlock:^(NSURL *url, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
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
