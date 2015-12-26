///
//  CCAlbumSetDetailViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCAlbumSetDetailViewController.h"
#import "CCSoundCell.h"
#import "CCGlobalHeader.h"
#import "CCPlayerViewController.h"
#import "CCPlayerBtn.h"


@interface CCAlbumSetDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CCAlbumSetDetailViewController

- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shuaxin" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.titleLabel.text = self.titleL;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusView.backgroundColor = STATUS_COLOR;
    [self createDataSource];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCSoundCell" bundle:nil] forCellReuseIdentifier:CCSOUNDCellID];
    [self registerNotification];
}

- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:@"shuaxin" object:nil];
}

- (void)notifi:(NSNotification *)notifi {
    [self createDataSource];
    [self.tableView reloadData];
}

- (void)createDataSource {
    [self.dataSource removeAllObjects];
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict[@"下载完成"];
    
    for (NSDictionary * dic in array) {
        if (self.albumId == [dic[@"albumId"] integerValue]) {
            [self.dataSource addObject:dic];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCSoundCell * cell = [tableView dequeueReusableCellWithIdentifier:CCSOUNDCellID forIndexPath:indexPath];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    cell.deleteBtn.tag = [dict[@"trackId"] integerValue];
    [cell.deleteBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleLabel.text = dict[@"title"];
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]]];
    cell.albumImageView.layer.cornerRadius = 30;
    cell.albumImageView.clipsToBounds = YES;
    cell.autherLabel.text = [NSString stringWithFormat:@"by %@", dict[@"userInfo"][@"nickname"]];
    
    
    NSInteger time = [dict[@"duration"]integerValue];
    cell.soundFullTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
    
    
    NSInteger i = [dict[@"playtimes"] integerValue];
    if (i > 10000) {
        cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
    }else {
        cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
    }
    
    cell.likesLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"likes"] integerValue]];
    
    NSInteger size = [dict[@"downloadSize"] integerValue];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%.2lfMB", (CGFloat)size/1024/1024];
    
    return cell;
}


- (void)onClicked:(UIButton *)btn {
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        if (btn.tag == [self.dataSource[i][@"trackId"] integerValue]) {
            
            // 从沙盒中删除音乐文件
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString * title = self.dataSource[i][@"title"];
            NSString * path1 = NSHomeDirectory();
            NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
            path1 = [path1 stringByAppendingPathComponent:str];
            [fileManager removeItemAtPath:path1 error:nil];
            
            
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = dict[@"下载完成"];
            
            for (NSDictionary * dic in array) {
                if ([dic[@"trackId"]integerValue] == [self.dataSource[i][@"trackId"]integerValue]) {
                    [array removeObject:dic];
                    break;
                }
            }

            [dict setObject:array forKey:@"下载完成"];
            [dict writeToFile:path atomically:YES];
            
        }
    }
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"shuaxin" object:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger i = indexPath.row;
    NSString * title = self.dataSource[i][@"title"];
    NSString * path1 = NSHomeDirectory();
    NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
    path1 = [path1 stringByAppendingPathComponent:str];
    
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    NSInteger trackId = [dict[@"trackId"] integerValue];
    NSInteger comment = [dict[@"comments"] integerValue];
    CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
    player.trackId = trackId;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger number = indexPath.row;
    [defaults setObject:@(number) forKey:CURRENT_SONGNUMBER];
    NSMutableArray * array = self.dataSource;
    NSString * name = dict[@"title"];
    [defaults setObject:name forKey:@"title"];
    [defaults setObject:array forKey:@"songlist"];
    [defaults setObject:@(trackId) forKey:@"trackid"];
    [defaults setObject:@(comment) forKey:@"comment"];
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





- (IBAction)backBtnDidClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
