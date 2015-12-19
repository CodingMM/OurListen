//
//  CCLiveTableViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCLiveTableViewController.h"
#import "CCGlobalHeader.h"
#import "CCLiveCell1.h"
#import "CCLiveCell2.h"
#import "CCPlayerViewController.h"
#import "CCPlayerBtn.h"
#import "CCLiveDetailViewController.h"
#import "CCLiveDetailViewController2.h"

@interface CCLiveTableViewController ()<CCLiveCell1Delegate>

@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation CCLiveTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCLiveCell1" bundle:nil] forCellReuseIdentifier:CCLIVECell1ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCLiveCell2" bundle:nil] forCellReuseIdentifier:CCLIVECell2ID];
    
    NSArray * imageArray = @[@"liveLocal", @"liveCountry", @"liveProvince", @"liveNet"];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 110)];
    view.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25 + i*(SCREEN_SIZE.width - 20)/4, 20, 53, 74);
        button.tag = 20 + i;
        [button addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        
        [view addSubview:button];
    }
    
    self.tableView.tableHeaderView = view;
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    [self downloadData];
    
}

- (void)btnDidClicked:(UIButton *)btn {
    
    if (btn.tag == 20) {
        
        CCLiveDetailViewController * liveD = [[CCLiveDetailViewController alloc] initWithNibName:@"CCLiveDetailViewController" bundle:nil];
        liveD.topTitle = @"本地台";
        liveD.radioType = 2;
        liveD.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liveD animated:YES];
    }else if (btn.tag == 21) {
        
        CCLiveDetailViewController * liveD = [[CCLiveDetailViewController alloc] initWithNibName:@"CCLiveDetailViewController" bundle:nil];
        liveD.topTitle = @"国家台";
        liveD.radioType = 1;
        liveD.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liveD animated:YES];
        
    }else if (btn.tag == 22) {
        
        CCLiveDetailViewController2 * liveD = [[CCLiveDetailViewController2 alloc] initWithNibName:@"CCLiveDetailViewController2" bundle:nil];
        liveD.topTitle = @"省市台";
        liveD.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liveD animated:YES];
        
    }else if (btn.tag == 23) {
        CCLiveDetailViewController * liveD = [[CCLiveDetailViewController alloc] initWithNibName:@"CCLiveDetailViewController" bundle:nil];
        liveD.topTitle = @"网络台";
        liveD.radioType = 3;
        liveD.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liveD animated:YES];
    }
}

- (void)downloadData {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * dict2 = dict[@"result"];
        NSArray * array = dict2[@"recommandRadioList"];
        [self.dataSource addObject:array];
        
        NSArray * array2 = dict2[@"topRadioList"];
        [self.dataSource addObject:array2];
        
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}





#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else {
        return 60;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return [self.dataSource[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CCLiveCell1 * cell = [tableView dequeueReusableCellWithIdentifier:CCLIVECell1ID forIndexPath:indexPath];
        cell.delegate = self;
        NSArray * array = self.dataSource[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadDataWithData:array];
        return cell;
    }else if (indexPath.section == 1) {
        CCLiveCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCLIVECell2ID forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * dict = array[indexPath.row];
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
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"dfsadf";
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        label.text = @"推荐电台";
        [view addSubview:label];
        return view;
    }else if (section == 1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        label.text = @"排行榜";
        
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    if (indexPath.section == 1) {
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * dict = array[indexPath.row];
        
        NSInteger radioId = [dict[@"radioId"] integerValue];
        CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
        player.audioId = radioId;
        player.type = 2;
        player.programId = 2;
        
        [self presentViewController:player animated:YES completion:^{
            CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
            playerBtn.hidden = YES;
            [player createAudioPlayer];
        }];
        
    }
}


#pragma mark - CCLiveCell1Delegate

- (void)pushNextViewControllerWithRadioId:(NSInteger)radioId
{
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    player.audioId = radioId;
    player.type = 2;
    player.programId = 1;
    
    [self presentViewController:player animated:YES completion:^{
        CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
        playerBtn.hidden = YES;
        [player createAudioPlayer];
    }];
    
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
