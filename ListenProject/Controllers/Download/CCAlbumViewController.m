//
//  CCAlbumViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCAlbumViewController.h"
#import "CCGlobalHeader.h"
#import "CCDownloadAlbumCell.h"
#import "CCAlbumModel.h"
#import "CCAlbumSetDetailViewController.h"


@interface CCAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIView * alertView;

@property (nonatomic, strong) CCAlbumModel * model;

@property (nonatomic, strong) NSMutableArray * albumModelArray;

@property (nonatomic, assign) NSInteger tag1;

@end

@implementation CCAlbumViewController

- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shuaxin" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createAlertView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCDownloadAlbumCell" bundle:nil] forCellReuseIdentifier:CCDOWNLOADALBUMCELLID];
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
        label.text = @"亲，您还没有下载过一首专辑哦~~~";
        [self.alertView addSubview:label];
        [self.view addSubview:self.alertView];
    }
}

- (void)createDataSource {
    self.albumModelArray = [[NSMutableArray alloc] init];
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict[@"下载完成"];
    
    [self.dataSource removeAllObjects];
    [self.albumModelArray removeAllObjects];
    
    
    [self tongjizhuanjishuWithArray:array];
    
    self.dataSource = self.albumModelArray;
}

- (void)tongjizhuanjishuWithArray:(NSMutableArray *)array
{

    NSInteger jj = 0;
    NSInteger llll = 0;
    while (array.count > 0) {
        NSDictionary * dict = array[jj];
        
        CCAlbumModel * model = [[CCAlbumModel alloc] init];
        model.num = 0;
        model.dict = dict;
        model.albumId = [dict[@"albumId"] integerValue];
        [self.albumModelArray addObject:model];
        
        for (NSInteger i = 0; i < array.count; i++) {
            if (array[i][@"albumId"] == dict[@"albumId"]) {
                CCAlbumModel * model = self.albumModelArray[llll];
                model.num = model.num + 1;
                [array removeObjectAtIndex:i];
                i--;
            }
        }
        llll++;
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
    CCDownloadAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:CCDOWNLOADALBUMCELLID forIndexPath:indexPath];
    
    CCAlbumModel * model = self.dataSource[indexPath.row];
    NSDictionary * dict = model.dict;

    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]]];
    cell.titelLabel.text = dict[@"albumTitle"];
    
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * array = dict1[@"下载完成"];
    NSInteger size = 0;
    for (NSDictionary * dic in array) {
        if ([dic[@"albumId"]integerValue] == model.albumId) {
            size = size + [dic[@"downloadSize"]integerValue];
        }
    }
    
    cell.sizeLabel.text = [NSString stringWithFormat:@"%.2lfMB", (CGFloat)size/1024/1024];
    cell.autherLabel.text = [NSString stringWithFormat:@"by %@", dict[@"userInfo"][@"nickname"]];
    cell.soundsNumLabel.text = [NSString stringWithFormat:@"%ld集", model.num];
    
    cell.deleteBtn.tag = [dict[@"albumId"] integerValue];
    [cell.deleteBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)onClicked:(UIButton *)btn {
    self.tag1 = btn.tag;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定清空所选的专辑？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.delegate = self;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        for (NSInteger i = 0; i < self.dataSource.count; i++) {
            CCAlbumModel * model = self.dataSource[i];
            if (self.tag1 == model.albumId) {
                
                // 从沙盒中删除音乐文件
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSString * path = NSHomeDirectory();
                path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
                NSMutableArray * array = dict[@"下载完成"];
                
                for (NSInteger j = 0; j < array.count; j++) {
                    if ([array[j][@"albumId"] integerValue] == model.albumId) {
                        
                        NSString * title = array[j][@"title"];
                        NSString * path1 = NSHomeDirectory();
                        NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
                        path1 = [path1 stringByAppendingPathComponent:str];
                        [fileManager removeItemAtPath:path1 error:nil];
                        
                        [array removeObjectAtIndex:j];
                        j--;
                    }
                }
                
                [dict setObject:array forKey:@"下载完成"];
                [dict writeToFile:path atomically:YES];
                
            }
        }
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"shuaxin" object:nil];
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCAlbumSetDetailViewController * vc = [[CCAlbumSetDetailViewController alloc] initWithNibName:@"CCAlbumSetDetailViewController" bundle:nil];
    CCAlbumModel * model = self.dataSource[indexPath.row];
    NSDictionary * dict = model.dict;
    NSString * str = dict[@"albumTitle"];
    vc.titleL = str;
    NSInteger albumId = [dict[@"albumId"] integerValue];

    vc.albumId = albumId;
    [self.navigationController pushViewController:vc animated:YES];
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
