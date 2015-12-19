//
//  CCRecomViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCRecomViewController.h"
#import "ImagesScrollView.h"
#import "CCGlobalHeader.h"
#import "CCTableHeaderView.h"
#import "CCRecomCell.h"
#import "CCRecomCell2.h"
#import "CCRecomCell3.h"
#import "CCRecomCell4.h"
//专辑详情
#import "CCAlbumDetailViewController.h"
#import "CCListenListViewController.h"
#import "CCPlayerBtn.h"

@interface CCRecomViewController ()<ImagesScrollViewDelegate,CCRecomCellDelegate,CCAlbumDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * focusImageArray;
@property (nonatomic, strong) NSMutableArray * sectionTitleArray;

@end

@implementation CCRecomViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    [self downloadData];
    
}
#pragma mark - Helper Methods
- (void)createTableView {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[CCTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, 200)];
    self.tableView.tableHeaderView = view;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCRecomCell" bundle:nil] forCellReuseIdentifier:CCRECOMCellID1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCRecomCell2" bundle:nil] forCellReuseIdentifier:CCRECOMCellID2];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCRecomCell3" bundle:nil] forCellReuseIdentifier:CCRECOMCellID3];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCRecomCell4" bundle:nil] forCellReuseIdentifier:CCRECOMCellID4];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)downloadData {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=and-d10&device=android&includeActivity=true&includeSpecial=true&scale=2&version=4.3.14.3" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"focusImages"][@"list"];
        for (NSDictionary * dict in array) {
            NSString * str = dict[@"pic"];
            [self.focusImageArray addObject:str];
        }
        ImagesScrollView * view = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, 200)];
        view.delegate = self;
        view.isLoop = YES;
        view.autoScrollInterval = 3;
        self.tableView.tableHeaderView = view;
        
        NSArray * tuijianArray = dict[@"editorRecommendAlbums"][@"list"];
        [self.dataSource addObject:tuijianArray];
        
        NSArray * jingpinArray = dict[@"specialColumn"][@"list"];
        [self.dataSource addObject:jingpinArray];
        
        
        NSArray * renmenArray = dict[@"hotRecommends"][@"list"];
        for (NSDictionary * dict in renmenArray) {
            NSArray * array = dict[@"list"];
            [self.dataSource addObject:array];
        }
        
        NSArray * array11 = [[NSArray alloc] init];
        [self.dataSource addObject:array11];
        
        NSArray * zhiboArray = dict[@"entrances"][@"list"];
        [self.dataSource addObject:zhiboArray];
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];

    }];
    
}

/**
 *  懒加载
 */

#pragma mark - Getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)focusImageArray
{
    if (_focusImageArray == nil) {
        _focusImageArray = [[NSMutableArray alloc] init];
    }
    return _focusImageArray;
}

- (NSMutableArray *)sectionTitleArray
{
    if (_sectionTitleArray == nil) {
        _sectionTitleArray = [[NSMutableArray alloc] init];
    }
    return _sectionTitleArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else if(indexPath.section == 1) {
        return 60;
    }else if(indexPath.section == self.dataSource.count - 2) {
        return 50;
    }else if(indexPath.section == self.dataSource.count - 1) {
        return 50;
    }
    return 150;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1) {
        return [self.dataSource[section] count];
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CCRecomCell * cell = [tableView dequeueReusableCellWithIdentifier:CCRECOMCellID1 forIndexPath:indexPath];
        cell.delegate = self;
        NSArray * array = self.dataSource[indexPath.section];
        [cell reloadDataWithData:array];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 1) {
        CCRecomCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCRECOMCellID2 forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        
        NSDictionary * item = array[indexPath.row];
        NSURL * url1 = [NSURL URLWithString:item[@"coverPath"]];
        [cell.imageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage alloc]];
        cell.titleLabel1.text = item[@"title"];
        cell.detailLabel1.text = item[@"subtitle"];
        cell.numberLabel1.text = item[@"footnote"];
        
        return cell;
    }
    
    for (NSInteger i = 2; i < self.dataSource.count - 2; i++) {
        if (indexPath.section == i) {
            
            CCRecomCell * cell = [tableView dequeueReusableCellWithIdentifier:CCRECOMCellID1 forIndexPath:indexPath];
            NSArray * array = self.dataSource[indexPath.section];
            cell.delegate = self;
            [cell reloadDataWithData:array];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    if (indexPath.section == self.dataSource.count - 2) {
        
        CCRecomCell4 * cell = [tableView dequeueReusableCellWithIdentifier:CCRECOMCellID4 forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == self.dataSource.count - 1) {
        
        CCRecomCell4 * cell = [tableView dequeueReusableCellWithIdentifier:CCRECOMCellID4 forIndexPath:indexPath];
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * item = array[indexPath.row];
        NSURL * url = [NSURL URLWithString:item[@"coverPath"]];
        [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage alloc]];
        cell.titleLabel.text = item[@"title"];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CCTableHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (section == 0) {
        view.sectionTitleLabel.text = @"小编推荐";
        return view;
    }else if(section == 1) {
        view.sectionTitleLabel.text = @"精品听单";
        return view;
    }else if(section == 2) {
        view.sectionTitleLabel.text = @"听新闻";
        return view;
    }else if(section == 3) {
        view.sectionTitleLabel.text = @"听小说";
        return view;
    }else if(section == 4) {
        view.sectionTitleLabel.text = @"听脱口秀";
        return view;
    }else if(section == 5) {
        view.sectionTitleLabel.text = @"听相声";
        return view;
    }else if(section == 6) {
        view.sectionTitleLabel.text = @"听音乐";
        return view;
    }else if(section == 7) {
        view.sectionTitleLabel.text = @"听情感心声";
        return view;
    }else if(section == 8) {
        view.sectionTitleLabel.text = @"听历史";
        return view;
    }else if(section == 9) {
        view.sectionTitleLabel.text = @"听讲座";
        return view;
    }else if(section == 10) {
        view.sectionTitleLabel.text = @"听广播剧";
        return view;
    }else if(section == 11) {
        view.sectionTitleLabel.text = @"听儿童故事";
        return view;
    }else if(section == 12) {
        view.sectionTitleLabel.text = @"听外语";
        return view;
    }else if(section == 13) {
        view.sectionTitleLabel.text = @"听游戏";
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section >= self.dataSource.count - 2) {
        return 0;
    }
    
    return 40;
}


#pragma mark - imageScrollViewDelegate
- (NSInteger)numberOfImagesInImagesScrollView:(ImagesScrollView *)imagesScrollView {
    return self.focusImageArray.count;
}

- (NSString *)imagesScrollView:(ImagesScrollView *)imagesScrollView imageUrlStringWithIndex:(NSInteger)index {
    return self.focusImageArray[index];
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 在选中的瞬间，取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSArray * array = self.dataSource[indexPath.section];
        NSDictionary * item = array[indexPath.row];
        
        NSInteger i = [item[@"contentType"]integerValue];
        
        CCListenListViewController * listenVC = [[CCListenListViewController alloc] initWithNibName:@"CCListenListViewController" bundle:nil];
        listenVC.type = i;
        listenVC.specialId = [item[@"specialId"] integerValue];
        
        listenVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listenVC animated:YES];
        
    }
    if (indexPath.section == self.dataSource.count - 2) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(setScrollViewContentOffSet:)]) {
            
            CGFloat offsetX = 1 * SCREEN_SIZE.width;
            CGPoint offset = CGPointMake(offsetX, 0);
            [_delegate setScrollViewContentOffSet:offset];
        }
    }else if (indexPath.section == self.dataSource.count - 1) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(setScrollViewContentOffSet:)]) {
            
            CGFloat offsetX = 2 * SCREEN_SIZE.width;
            CGPoint offset = CGPointMake(offsetX, 0);
            [_delegate setScrollViewContentOffSet:offset];
        }
    }
}

#pragma mark - tableViewCell1Deleagte

- (void)pushNextViewControllerWithUid:(NSInteger)index
{
    CCAlbumDetailViewController * albumVC = [[CCAlbumDetailViewController alloc] initWithNibName:@"CCAlbumDetailViewController" bundle:nil];
    albumVC.delegate = self;
    albumVC.hidesBottomBarWhenPushed = YES;
    albumVC.index = index;
    [self.navigationController pushViewController:albumVC animated:YES];
}

- (void)reloadDataWithAlbumId:(NSInteger)albumId
{
    CCAlbumDetailViewController * albumVC = [[CCAlbumDetailViewController alloc] initWithNibName:@"CCAlbumDetailViewController" bundle:nil];
    albumVC.delegate = self;
    albumVC.hidesBottomBarWhenPushed = YES;
    albumVC.index = albumId;
    [self.navigationController pushViewController:albumVC animated:YES];
}


@end
