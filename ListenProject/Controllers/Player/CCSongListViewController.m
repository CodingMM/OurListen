//
//  CCSongListViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCSongListViewController.h"
#import "CCGlobalHeader.h"
#import "CCPlayerViewController.h"

@interface CCSongListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CCSongListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadData];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidDisappear:(BOOL)animated{

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusView.backgroundColor = STATUS_COLOR;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
}



- (IBAction)backBtnDidClicked:(id)sender {
    
    [[CCPlayerViewController sharePlayerViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)downloadData {
    
    self.dataSource = self.songList;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.currentNum) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        NSDictionary * dict = self.dataSource[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }else {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    NSInteger trackId = [dict[@"trackId"] integerValue];
    NSInteger comment = [dict[@"comments"] integerValue];
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    player.trackId = trackId;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger number = indexPath.row;
    [defaults setObject:@(number) forKey:CURRENT_SONGNUMBER];
    [defaults synchronize];
    
    player.name = dict[@"title"];
    player.commentNum = comment;
    player.songList = self.dataSource;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [player createPlayer];
        [player reloadData];
    }];
    
}

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
