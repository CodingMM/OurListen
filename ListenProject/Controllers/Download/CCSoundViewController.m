//
//  CCSoundViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCSoundViewController.h"
#import "CCGlobalHeader.h"
#import "CCSoundCell.h"
#import "CCSortViewController.h"
#import "CCPlayerBtn.h"
#import "CCPlayerViewController.h"


@interface CCSoundViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIView * alertView;

@end

@implementation CCSoundViewController
- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shuaxin" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    [self createAlertView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCSoundCell" bundle:nil] forCellReuseIdentifier:CCSOUNDCellID];
    [self registerNotification];
}
- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:@"shuaxin" object:nil];
}

- (void)notifi:(NSNotification *)notifi {
    [self.alertView removeFromSuperview];
    [self createDataSource];
    [self createAlertView];
    [self.tableView reloadData];
}


- (void)createAlertView {
    if (self.dataSource.count == 0) {
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_SIZE.width - 100, 120)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 100, 120)];
        label.text = @"亲，您还没有下载过一首声音哦~~~";
        [self.alertView addSubview:label];
        [self.view addSubview:self.alertView];
    }
}

- (void)createDataSource {
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict[@"下载完成"];
    
    self.dataSource = array;
    
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
            
            
            [self.dataSource removeObjectAtIndex:i];
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = self.dataSource;
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
    // 获取到当前选中的Cell
//    soundTableViewCell * cell = (soundTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
//    NSInteger i = indexPath.row;
//    NSString * title = self.dataSource[i][@"title"];
//    NSString * path1 = NSHomeDirectory();
//    NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
//    path1 = [path1 stringByAppendingPathComponent:str];
    
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_SIZE.width/2, 50);
    UIImage * image = [[UIImage imageNamed:@"btn_downloadsound_clear_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImage * image2 = [[UIImage imageNamed:@"btn_downloadsound_clear_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image2 forState:UIControlStateSelected];


    [view addSubview:button];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(SCREEN_SIZE.width/2, 0, SCREEN_SIZE.width/2, 50);
    UIImage * image3 = [[UIImage imageNamed:@"btn_downloadsound_list_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 setImage:image3 forState:UIControlStateNormal];
    UIImage * image4 = [[UIImage imageNamed:@"btn_downloadsound_list_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button2 setImage:image4 forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(paixuBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)paixuBtnDidClicked:(UIButton *)btn
{
    CCSortViewController * vc = [[CCSortViewController alloc] initWithNibName:@"CCSortViewController" bundle:nil];
    vc.dataSource = self.dataSource;
    [self presentViewController:vc animated:YES completion:^{
        CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
        playerBtn.hidden = YES;
        [vc.tabBarController.tabBar setHidden:YES];
    }];
}

- (void)deleteBtnDidClicked:(UIButton *)btn
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定清空所有下载的声音？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.delegate = self;
    [alert show];
}

//点击按钮时触发
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        for (NSInteger i = 0; i < self.dataSource.count; i++) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString * title = self.dataSource[i][@"title"];
            NSString * path1 = NSHomeDirectory();
            NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
            path1 = [path1 stringByAppendingPathComponent:str];
            [fileManager removeItemAtPath:path1 error:nil];
        }
        
        [self.dataSource removeAllObjects];
        NSString * path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray * array = self.dataSource;
        [dict setObject:array forKey:@"下载完成"];
        [dict writeToFile:path atomically:YES];
        
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"shuaxin" object:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
