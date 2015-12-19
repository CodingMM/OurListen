//
//  CCHistoryViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCHistoryViewController.h"
#import "CCHistoryCell.h"
#import "CCGlobalHeader.h"


@interface CCHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CCHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createData];
}

#pragma mark - Helper Methods

- (void)createTableView {
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCHistoryCell" bundle:nil] forCellReuseIdentifier:CCHISTORYCellID];
    
}

- (void)createData {
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/historyArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict[@"浏览历史"];
    self.dataSource = array;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:CCHISTORYCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.row];
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"albumImage"]]];
    cell.titleLabel.text = dict[@"albumTitle"];
    cell.introLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //发送
    [center postNotificationName:@"history" object:nil userInfo:@{@"data":dict}];
}


- (IBAction)deleteHistoryBtnDidClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定清空播放历史？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString * path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/historyArray.plist"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray * array = dict[@"浏览历史"];
        [array removeAllObjects];
        [dict setObject:array forKey:@"浏览历史"];
        [dict writeToFile:path atomically:YES];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
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
