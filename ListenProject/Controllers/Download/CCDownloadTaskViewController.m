//
//  CCDownloadTaskViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/9.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCDownloadTaskViewController.h"
#import "CCGlobalHeader.h"
#import "CCDownloadCell.h"
#import "CCDownloadManager.h"
#import "UIProgressView+AFNetworking.h"


@interface CCDownloadTaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIView * alertView;

@end

@implementation CCDownloadTaskViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"CCDownloadCell" bundle:nil] forCellReuseIdentifier:CCDOWNLOADCellID];
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
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_SIZE.width, 120)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 120)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"亲，没有下载任务哦~~~";
        [self.alertView addSubview:label];
        [self.view addSubview:self.alertView];
    }
    
}

- (void)createDataSource {
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict[@"正在下载"];
    
    self.dataSource = array;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCDownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:CCDOWNLOADCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]]];
    cell.albumImageView.layer.cornerRadius = 30;
    cell.albumImageView.clipsToBounds = YES;
    cell.songerLabel.text = [NSString stringWithFormat:@"by %@", dict[@"userInfo"][@"nickname"]];
    
    NSInteger i = [dict[@"playtimes"] integerValue];
    if (i > 10000) {
        cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
    }else {
        cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
    }
    
    NSInteger time = [dict[@"duration"]integerValue];
    cell.commentNumLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
    
    cell.loveNumLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"likes"] integerValue]];
    cell.playTimeLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"comments"] integerValue]];
    
    // 获取当前下载队列里的下载任务，
    NSArray * array = [CCDownloadManager downloadTasks];
    for (NSURLSessionDownloadTask * task in array) {
        // 获取当前下载任务的url
        NSString * str = task.response.URL.absoluteString;
        // 判断是否是该cell的下载任务
        if ([str isEqualToString:dict[@"downloadUrl"]]) {
            // 让进度条随着下载进度而变化
            //            [cell.progress setProgressWithDownloadProgressOfTask:task animated:YES];
        }
    }
    [self jisuanProgress];
    
    return cell;
}

//计算下载进度
- (void)jisuanProgress {
    
    [[CCDownloadManager sharedManager] setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSString * urlStr = downloadTask.response.URL.absoluteString;
        for (NSInteger i = 0; i < self.dataSource.count; i++) {
            NSDictionary * dict = self.dataSource[i];
            NSString * str = dict[@"downloadUrl"];
            if ([urlStr isEqualToString:str]) {
                float p = totalBytesWritten/(float)totalBytesExpectedToWrite;
                
                // 这个block是异步的，用以下代码把它加到主线程中
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CCDownloadCell * cell = (CCDownloadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                    cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f%%", p * 100];
                    
                    cell.progress.progress = p;
                    
                });
            }
        }
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    // 获取到当前选中的cell
    CCDownloadCell * cell = (CCDownloadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
// 刷新当前选中的cell
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    NSArray * array = [CCDownloadManager downloadTasks];
    BOOL flag = NO;
    // 获取下载队列并匹配
    for (NSURLSessionDownloadTask * task in array) {
        NSString * str = task.response.URL.absoluteString;
        if ([str isEqualToString:dict[@"downloadUrl"]]) {
            if (task.state == 0) {
                [task suspend];
                cell.downloadingLabel.text = @"暂停下载";
            }else if (task.state == 1) {
                [task resume];
                cell.downloadingLabel.text = @"正在下载";
            }
            flag = YES;
            break;
        }
    }
    
    // 如果下载队列中没有，则说明是中断了的下载，去Plist文件里查找
    if (flag == NO) {
        
        NSString * path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
        NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray * array = dict1[@"正在下载"];
        
        for (NSMutableDictionary * dic in array) {
            // 如果存在resumeData，就取出来并继续下载
            if (dic[@"resumeData"]) {
                NSData * data = dic[@"resumeData"];
                NSData * resumeData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSURLSessionDownloadTask * task = [CCDownloadManager downloadDataWithResumeData:resumeData andTitle:dict[@"title"]];
                
                [cell.progress setProgressWithDownloadProgressOfTask:task animated:YES];
                
                [self jisuanProgress];
                
                /*
                [[CCDownloadManager sharedManager] setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                    
                    if (downloadTask == task) {
                        float p = totalBytesWritten/(float)totalBytesExpectedToWrite;
                        
                        // 这个block是异步的，用以下代码把它加到主线程中
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f%%", p * 100];
                        });
                    }
                }];
                */
            }
        }
        flag = YES;
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
