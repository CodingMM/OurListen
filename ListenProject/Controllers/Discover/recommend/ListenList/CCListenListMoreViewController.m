//
// CCListenListMoreViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCListenListMoreViewController.h"
#import "CCGlobalHeader.h"
#import "CCListenListCell4.h"
#import "CCListenListViewController.h"




@interface CCListenListMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) NSInteger pageNum;


@end

@implementation CCListenListMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusView.backgroundColor = STATUS_COLOR;
    [self downloadData];
    [self createTabelView];
    
}
- (void)downloadData {
    self.pageNum = 1;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/subject_list?device=android&page=%ld&per_page=10", self.pageNum];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"list"];
        for (NSDictionary * dic in array) {
            NSMutableArray * subArray = [[NSMutableArray alloc] init];
            [subArray addObject:dic];
            [self.dataSource addObject:subArray];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)createTabelView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell4" bundle:nil] forCellReuseIdentifier:CCLISTENCell4ID];
    
    /*
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y -= 64;
    [self.progressHUD showInRect:rect inView:self.view animated:YES];
     */
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    
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

- (void)loadmoreData
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/subject_list?device=android&page=%ld&per_page=10", self.pageNum+1];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"list"];
        for (NSDictionary * dic in array) {
            NSMutableArray * subArray = [[NSMutableArray alloc] init];
            [subArray addObject:dic];
            [self.dataSource addObject:subArray];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.tableView reloadData];
        self.pageNum++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCListenListCell4 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell4ID forIndexPath:indexPath];
    NSArray * array = self.dataSource[indexPath.section];
    NSDictionary * dict = array[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    cell.introLabel.text = dict[@"subtitle"];
    cell.footnoteLabel.text = dict[@"footnote"];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverPathSmall"]]];
    cell.timeLabel.text = @"2015/10/22";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataSource[indexPath.section];
    NSDictionary * item = array[indexPath.row];
    
    NSInteger i = [item[@"contentType"]integerValue];
    
    CCListenListViewController * ting = [[CCListenListViewController alloc] initWithNibName:@"CCListenListViewController" bundle:nil];
    ting.type = i;
    ting.specialId = [item[@"specialId"] integerValue];
    
    ting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ting animated:YES];
}


- (IBAction)backBtnDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableArray * )dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}




@end
