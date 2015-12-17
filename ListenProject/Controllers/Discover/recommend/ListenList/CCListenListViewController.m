//
//  CCListenListViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCListenListViewController.h"
#import "CCGlobalHeader.h"
#import "CCListenListCell1.h"
#import "CCListenListCell2.h"
#import "CCListenListCell3.h"
#import "CCTableHeaderView.h"
#import "CCMethod.h"
#import "CCAlbumDetailViewController.h"
#import "CCListenListMoreViewController.h"
#import "CCPlayerViewController.h"
#import "UIImageView+WebCache.h"
#import "CCPlayerBtn.h"



@interface CCListenListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

//@property (nonatomic, strong) JGProgressHUD * progressHUD;

@end

@implementation CCListenListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[CCTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell1" bundle:nil] forCellReuseIdentifier:CCLISTENCell1ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell2" bundle:nil] forCellReuseIdentifier:CCLISTENCell2ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell3" bundle:nil] forCellReuseIdentifier:CCLISTENCell3ID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    
}

#pragma mark - Helper Methods

- (void)createDataSource
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/subject_detail?device=android&id=%ld", self.specialId];
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * dic = dict[@"info"];
        NSArray * array = @[dic];
        [self.dataSource addObject:array];
        
        NSArray * array2 = dict[@"list"];
        [self.dataSource addObject:array2];
        
        NSArray * array3 = @[@"更多"];
        [self.dataSource addObject:array3];
        
        
        [SVProgressHUD dismiss];
        
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * dict = array[indexPath.row];
        NSString * str = dict[@"intro"];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 16, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat h = rect.size.height + 160;
        return h;
    }else if (indexPath.section == 1) {
        return 85;
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 30;
    }else if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else if (section == 1) {
        return 10;
    }else if (section == 2) {
        return 100;
    }
    return 0;
}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else if (section == 1) {
        CCTableHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        view.sectionTitleLabel.text = @"听单列表";
        view.sectionTitleLabel.font = [UIFont systemFontOfSize:14];
        return view;
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CCListenListCell1 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell1ID forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * dict = array[indexPath.row];
        cell.titleLabel.text = dict[@"title"];
        cell.introLabel.text = dict[@"intro"];
        [cell.autherImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"smallLogo"]]];
        cell.autherImageView.layer.cornerRadius = 10;
        cell.autherImageView.clipsToBounds = YES;
        cell.autherLabel.text = dict[@"nickname"];
        return cell;
    }else if (indexPath.section == 1) {
        
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * dict = array[indexPath.row];
        
        if (self.type == 1) {
            CCListenListCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell2ID forIndexPath:indexPath];
            [cell.tingdanImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"albumCoverUrl290"]]];
            cell.titleLabel.text = dict[@"title"];
            cell.introLabel.text = dict[@"intro"];
            
            NSInteger i = [dict[@"playsCounts"]integerValue];
            if (i > 10000) {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
            }else {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
            }
            
            cell.listLabel.text = [NSString stringWithFormat:@"%ld集", [dict[@"tracksCounts"]integerValue]];

            return cell;
        }if (self.type == 2) {
            
            CCListenListCell3 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell3ID forIndexPath:indexPath];
            [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"coverSmall"]]];
            cell.albumImageView.layer.cornerRadius = 35;
            cell.albumImageView.clipsToBounds = YES;
            cell.titleLabel.text = dict[@"title"];
            NSString * str = [NSString stringWithFormat:@"by %@", dict[@"nickname"]];
            cell.infoLabel.text = str;
            
            NSInteger i = [dict[@"playsCounts"]integerValue];
            if (i > 10000) {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
            }else {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
            }
            
            NSInteger time = [dict[@"duration"]integerValue];
            cell.soundFullTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
            
            cell.likesLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"favoritesCounts"]integerValue]];
            
            cell.commentLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"commentsCounts"]integerValue]];
            
            cell.createTimeLabel.text = @"";
            
            NSInteger time1 = [dict[@"createdAt"]integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time1/1000];
            cell.createTimeLabel.text = [CCMethod passedTimeSince:date];
            
            return cell;
        }
        

    }else if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        NSString * str = array[indexPath.row];
        cell.textLabel.text = str;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (self.type == 1) {
            NSArray * array = self.dataSource[indexPath.section];
            NSDictionary * dict = array[indexPath.row];
            NSInteger i = [dict[@"id"]integerValue];
            CCAlbumDetailViewController * album = [[CCAlbumDetailViewController alloc] initWithNibName:@"CCAlbumDetailViewController" bundle:nil];
            
            album.hidesBottomBarWhenPushed = YES;
            album.index = i;
            [self.navigationController pushViewController:album animated:YES];
        }else if (self.type == 2) {
            
            NSArray * array1 = self.dataSource[indexPath.section];
            NSDictionary * dict = array1[indexPath.row];
            NSInteger trackId = [dict[@"id"] integerValue];
            NSInteger comment = [dict[@"commentsCounts"] integerValue];
            CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
            player.trackId = trackId;
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSInteger number = indexPath.row;
            [defaults setObject:@(number) forKey:CURRENT_SONGNUMBER];

            [defaults setObject:array1 forKey:@"songlist"];
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
    }
    
    if (indexPath.section == 2) {
        
        CCListenListMoreViewController * view = [[CCListenListMoreViewController alloc] initWithNibName:@"CCListenListMoreViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];

    }
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
