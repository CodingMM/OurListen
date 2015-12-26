//
//  CCAddMoreViewController.m
//  ListenProject
//
//  Created by Elean on 15/12/26.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "CCAddMoreViewController.h"
#import "CCScannerViewController.h"
#import "CCPlayerBtn.h"
#import "CCGlobalHeader.h"
#import "AppDelegate.h"
#import "APPVersionCheck.h"

#define CELL_HEIGHT 60

@interface CCAddMoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation CCAddMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareView];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    CCPlayerBtn *payerBtn = [CCPlayerBtn sharePlayerBtn];
    payerBtn.hidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewWillDisappear:animated];
}

- (void)prepareView{

    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64)];
    statusView.backgroundColor = STATUS_COLOR;
    [self.view addSubview:statusView];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, 44)];
    titleLabel.text = @"更多";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
   
    [self.view addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 20, 30, 44)];
    [backBtn setImage:[UIImage imageNamed:@"liveRadioPlayingBack.jpg"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    
    CGFloat  currentVersion = [[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];

    NSString * version = [NSString stringWithFormat:@"版本检测                  %.1f",currentVersion];
     _dataArray = [NSMutableArray arrayWithObjects:@"扫一扫",version,nil];
    
    CGRect rect = CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    
    if (_dataArray.count * CELL_HEIGHT < rect.size.height) {
        rect.size.height = _dataArray.count * CELL_HEIGHT;
    }
    _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
   
    
    
    
}

#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = STATUS_COLOR;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        CCScannerViewController *scannerView = [[CCScannerViewController alloc]init];
        [self.navigationController pushViewController:scannerView animated:YES];
    }else if(indexPath.row == 1)
    {
        __weak CCAddMoreViewController *weekSelf = self;
       [APPVersionCheck versionCheck:^(BOOL haveNew, NSURL *downloadUrl) {
           
           if (haveNew) {
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新版本" message:@"有新版本上线了" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   
               }];
               UIAlertAction *update = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [[UIApplication sharedApplication] openURL:downloadUrl];
               }];
               [alert addAction:cancel];
               [alert addAction:update];
               [weekSelf presentViewController:alert animated:YES completion:nil];

           }else
           {
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新版本" message:@"当前版本已是最新版本" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               }];
               [alert addAction:sure];
               [weekSelf presentViewController:alert animated:YES completion:nil];
           }
           
       }];
    }
    
}

#pragma mark -- delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CELL_HEIGHT;
}

#pragma mark -- back click event
- (void)backClick:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];
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
