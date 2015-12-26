//
//  CCPlayerCommonTableViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCPlayerCommonTableViewController.h"
#import "CCGlobalHeader.h"
#import "CCPlayerCommonCell.h"
#import "CCMethod.h"
#import "DataAPI.h"

@interface CCPlayerCommonTableViewController ()

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) AFHTTPSessionManager * manager;
@property (nonatomic, assign) NSInteger trackid;


@end

@implementation CCPlayerCommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCPlayerCommonCell" bundle:nil] forCellReuseIdentifier:CCPLAYERCOMMONCellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak CCPlayerCommonTableViewController *weakself = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakself loadmoreData];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)downloadDataWithTrackId:(NSInteger)trackId {
    self.trackid = trackId;
    self.currentPage = 1;
    
    
    [DataAPI getCommentDetailWithTrackId:trackId andPageId:self.currentPage andSuccessBlock:^(NSURL *url, id data) {
        [self.dataSource removeAllObjects];
        
        NSDictionary *json = (NSDictionary *)data;
        
        NSArray * array = json[@"list"];
        for (NSDictionary * dict in array) {
            [self.dataSource addObject:dict];
        }
        
        self.totalCount = [json[@"totalCount"] integerValue];
        
        [self.tableView reloadData];
    } andFailBlock:^(NSURL *url, NSError *error) {
        
    }];
    
   }

- (void)loadmoreData
{
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/track/comment?trackId=%ld&pageSize=15&pageId=%ld", self.trackid, self.currentPage + 1];
    
    [self.manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = json[@"list"];
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



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = self.dataSource[indexPath.row][@"content"];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(303, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat h = rect.size.height + 40;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCPlayerCommonCell  *cell = [tableView dequeueReusableCellWithIdentifier:CCPLAYERCOMMONCellID forIndexPath:indexPath];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    cell.userNameLabel.text = dict[@"nickname"];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"smallHeader"]]];
    cell.detailCommentLabel.text = dict[@"content"];
    
    
    NSInteger time = [dict[@"createdAt"]integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    cell.timeLabel.text = [CCMethod passedTimeSince:date];;

    
    cell.floorNumberLabel.text = [NSString stringWithFormat:@"第%ld楼", self.totalCount - indexPath.row];
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource
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
