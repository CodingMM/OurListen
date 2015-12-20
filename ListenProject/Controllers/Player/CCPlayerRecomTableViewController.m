//
//  CCPlayerRecomTableViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCPlayerRecomTableViewController.h"
#import "CCGlobalHeader.h"
#import "CCPlayerRecomCell.h"
#import "CCPlayerViewController.h"

@interface CCPlayerRecomTableViewController ()

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableViewHeaderFooterView * headerView;

@end

@implementation CCPlayerRecomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCPlayerRecomCell" bundle:nil] forCellReuseIdentifier:CCPLAYERRECOMCellID];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)downloadDataWithTrackId:(NSInteger)trackId {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = [NSString stringWithFormat:@"http://ar.ximalaya.com/rec-association/recommend/album?trackId=%ld", trackId];
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource removeAllObjects];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * dict = json[@"baseAlbum"];
      
        NSArray * array = @[dict];
        [self.dataSource addObject:array];
        
  
        
        NSArray * albumArr = json[@"albums"];
        NSMutableArray * subArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in albumArr) {
            [subArray addObject:dict];
        }
        [self.dataSource addObject:subArray];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCPlayerRecomCell * cell = [tableView dequeueReusableCellWithIdentifier:CCPLAYERRECOMCellID forIndexPath:indexPath];
    
    NSArray * array = self.dataSource[indexPath.section];
    NSDictionary * dict = array[indexPath.row];
    
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]]];
    cell.albumDetailLabel.text = dict[@"intro"];
    cell.albumTitle.text = dict[@"title"];
    
    NSInteger i = [dict[@"playsCounts"] integerValue];
    if (i > 10000) {
        cell.numberLabel.text = [NSString stringWithFormat:@"%.1lf万",(CGFloat)i/10000];
    }else {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",[dict[@"playsCounts"] integerValue]];
    }
    
    
    cell.countLabel.text = [NSString stringWithFormat:@"%ld集", [dict[@"tracks"] integerValue]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 10)];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    if (section == 0) {
        label.text = @"所属专辑";
    }else {
        label.text = @"相关专辑";
    }
    
    [self.headerView addSubview:label];
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = self.dataSource[indexPath.section];
    NSDictionary * dict = array[indexPath.row];
    
    NSInteger albumId = [dict[@"albumId"] integerValue];

    if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadDataWithAlbumId:)]) {
        [_delegate reloadDataWithAlbumId:albumId];
    }
    
    [[CCPlayerViewController sharePlayerViewController] dismissViewControllerAnimated:YES completion:nil];
    

}



#pragma mark - Getter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
    }
    return _dataSource;
}
@end
