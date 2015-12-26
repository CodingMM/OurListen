//
//  CCSearchViewController.m
//  ListenProject
//
//  Created by  on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCSearchViewController.h"
#import "CCAlbumDetailViewController.h"
#import "CCPlayerViewController.h"
#import "CCSearchCell.h"
#import "CCGlobalHeader.h"
#import "CCSegeView.h"
#import "CCHeaderView.h"
#import "CCListenListCell2.h"
#import "CCListenListCell3.h"
#import "CCMethod.h"
#import "DataAPI.h"
#import "CCPlayerBtn.h"
@interface CCSearchViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,CCSegeViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) CCSearchCell * cell;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableArray * dataSource2;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) NSInteger albumNum;
@property (nonatomic, assign) NSInteger soundNum;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) CCSegeView * sege;

@property (nonatomic, assign) NSInteger currentPage;


@end

@implementation CCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createDataSource];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCSearchCell" bundle:nil] forCellWithReuseIdentifier:@"CCSearchCell"];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    CCPlayerBtn *payerBtn = [CCPlayerBtn sharePlayerBtn];
    payerBtn.hidden = YES;
}
- (void)createDataSource
{
    
    [DataAPI getHotSearchDataWithSuccessBlock:^(NSURL *url, id data) {
        
        if ([ISNull isNilOfSender:data]) {
            
            [self.appDelegate showErrMsg:@"网络数据为空" WithInterval:1.0];
            return ;
        }
        
        NSDictionary *dict = (NSDictionary *)data;
        
        NSArray * array = dict[@"list"];
        self.dataSource = (NSMutableArray *)array;
        
        [self.collectionView reloadData];
        
        
    } andFailBlock:^(NSURL *url, NSError *error) {
         NSLog(@"%@", error);
        
    }];
    
}



- (IBAction)backBtnDidClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnDidClicked:(id)sender {
    self.index = 0;
    [self createTableView];
    [self downloadData];
    [self.view endEditing:YES];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - UICollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCSearchCell" forIndexPath:indexPath];
    cell.keyword = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"CCSearchCell" owner:nil options:nil][0];
    }
    _cell.keyword = self.dataSource[indexPath.row];
    return [_cell sizeForCell];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView removeFromSuperview];
    
    [self createTableView];
    self.index = 0;
    NSString * str = self.dataSource[indexPath.item];
    
    self.searchTF.text = str;
    
    [self downloadData];
}

#pragma mark - createTableView

- (void)createTableView {
    [self.tableView removeFromSuperview];
    [self.sege removeFromSuperview];
    
    self.sege = [[CCSegeView alloc] init];
    self.sege.frame = CGRectMake(0, 64, SCREEN_SIZE.width, 50);
    self.sege.delegate = self;
    [self.view addSubview:self.sege];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell2" bundle:nil]forCellReuseIdentifier:CCLISTENCell2ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CCListenListCell3" bundle:nil] forCellReuseIdentifier:CCLISTENCell3ID];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[CCHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    
    [self.view addSubview:self.tableView];
    

    [SVProgressHUD showWithStatus:@"加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    __weak CCSearchViewController * weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // NSLog(@"加载更多");
        [weakSelf loadmoreData];
    }];
}
- (void)loadmoreData {
    
    if (self.index == 1) {
        
        NSString * str = self.searchTF.text;
        NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString * urlStr = [NSString stringWithFormat:@"http://search.ximalaya.com/front/v1?device=android&condition=relation&core=album&kw=%@&page=%ld&rows=20&spellchecker=true", encodingString, self.currentPage+1];
        
        [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * array1 = dict[@"response"][@"docs"];
            for (NSDictionary * dic in array1) {
                [self.dataSource2 addObject:dic];
            }
            
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            [self.view endEditing:YES];
            self.currentPage++;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
    }else if (self.index == 2) {
        NSString * str = self.searchTF.text;
        NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString * urlStr = [NSString stringWithFormat:@"http://search.ximalaya.com/front/v1?device=android&condition=relation&core=track&kw=%@&page=%ld&rows=20&spellchecker=true", encodingString, self.currentPage+1];
        
        [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * array1 = dict[@"response"][@"docs"];
            for (NSDictionary * dic in array1) {
                [self.dataSource2 addObject:dic];
            }
            
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            [self.view endEditing:YES];
            self.currentPage++;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    
    
    
}


- (void)downloadData {
    
    NSString * str = self.searchTF.text;
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://search.ximalaya.com/front/v1?device=android&core=all&kw=%@&page=1&rows=3&spellchecker=true", encodingString];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource2 removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array1 = dict[@"album"][@"docs"];
        [self.dataSource2 addObject:array1];
        self.albumNum = [dict[@"album"][@"numFound"] integerValue];
        self.soundNum = [dict[@"track"][@"numFound"] integerValue];
        NSArray * array2 = dict[@"track"][@"docs"];
        [self.dataSource2 addObject:array2];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self.view endEditing:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)downloadData2 {
    
    self.currentPage = 1;
    NSString * str = self.searchTF.text;
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://search.ximalaya.com/front/v1?device=android&condition=relation&core=album&kw=%@&page=%ld&rows=20&spellchecker=true", encodingString, self.currentPage];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource2 removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array1 = dict[@"response"][@"docs"];
        for (NSDictionary * dic in array1) {
            [self.dataSource2 addObject:dic];
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self.view endEditing:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)downloadData3 {
    self.currentPage = 1;
    NSString * str = self.searchTF.text;
    NSString * encodingString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://search.ximalaya.com/front/v1?device=android&condition=relation&core=track&kw=%@&page=%ld&rows=20&spellchecker=true", encodingString, self.currentPage];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource2 removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array1 = dict[@"response"][@"docs"];
        for (NSDictionary * dic in array1) {
            [self.dataSource2 addObject:dic];
        }

        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self.view endEditing:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index == 0) {
        return self.dataSource2.count;
    }else {
        return 1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return [self.dataSource2[section] count];
    }else {
        return self.dataSource2.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        if (indexPath.section == 0) {
            CCListenListCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell2ID forIndexPath:indexPath];
            NSArray * array = self.dataSource2[indexPath.section];
            NSDictionary * dict = array[indexPath.row];
            
            NSString * str = dict[@"cover_path"];
            if ([str isKindOfClass:[NSNull class]]) {
                cell.tingdanImageView.image = [UIImage imageNamed:@"circle_image_small"];
            }else {
                [cell.tingdanImageView sd_setImageWithURL:[NSURL URLWithString:str]];
            }
            
            
            cell.titleLabel.text = dict[@"title"];
            cell.introLabel.text = dict[@"intro"];
            NSInteger i = [dict[@"play"] integerValue];
            if (i > 10000) {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
            }else {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
            }
            cell.listLabel.text = [NSString stringWithFormat:@"%@集", dict[@"tracks"]];
            return cell;
        }else if (indexPath.section == 1) {
            CCListenListCell3 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell3ID forIndexPath:indexPath];
            NSArray * array = self.dataSource2[indexPath.section];
            NSDictionary * dict = array[indexPath.row];
            
            NSString * urlStr = dict[@"album_cover_path"];
            if ([urlStr isKindOfClass:[NSNull class]]) {
                cell.albumImageView.image = [UIImage imageNamed:@"circle_image_small"];
            }else {
                [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            }
            
            cell.albumImageView.layer.cornerRadius = 35;
            cell.albumImageView.clipsToBounds = YES;
            cell.titleLabel.text = dict[@"title"];
            NSString * str = [NSString stringWithFormat:@"by %@", dict[@"nickname"]];
            cell.infoLabel.text = str;
            
            NSInteger i = [dict[@"count_play"]integerValue];
            if (i > 10000) {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
            }else {
                cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
            }
            
            NSInteger time = [dict[@"duration"]integerValue];
            cell.soundFullTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
            
            cell.likesLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"count_like"]integerValue]];
            
            cell.commentLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"count_like"]integerValue]];
            
            
            NSInteger time1 = [dict[@"updated_at"]integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time1/1000];
            cell.createTimeLabel.text = [CCMethod passedTimeSince:date];
            
            
            return cell;
        }
        
    }else if (self.index == 1) {
        CCListenListCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell2ID forIndexPath:indexPath];
        NSDictionary * dict = self.dataSource2[indexPath.row];
        
        NSString * str = dict[@"cover_path"];
        if ([str isKindOfClass:[NSNull class]]) {
            cell.tingdanImageView.image = [UIImage imageNamed:@"circle_image_small"];
        }else {
            [cell.tingdanImageView sd_setImageWithURL:[NSURL URLWithString:str]];
        }
        
        
        cell.titleLabel.text = dict[@"title"];
        cell.introLabel.text = dict[@"intro"];
        NSInteger i = [dict[@"play"] integerValue];
        if (i > 10000) {
            cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
        }else {
            cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
        }
        cell.listLabel.text = [NSString stringWithFormat:@"%@集", dict[@"tracks"]];
        return cell;
        
    }else if (self.index == 2) {
        CCListenListCell3 * cell = [tableView dequeueReusableCellWithIdentifier:CCLISTENCell3ID forIndexPath:indexPath];
        NSDictionary * dict = self.dataSource2[indexPath.row];
        NSString * urlStr = dict[@"album_cover_path"];
        if ([urlStr isKindOfClass:[NSNull class]]) {
            cell.albumImageView.image = [UIImage imageNamed:@"circle_image_small"];
        }else {
            [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        }
        cell.albumImageView.layer.cornerRadius = 35;
        cell.albumImageView.clipsToBounds = YES;
        cell.titleLabel.text = dict[@"title"];
        NSString * str = [NSString stringWithFormat:@"by %@", dict[@"nickname"]];
        cell.infoLabel.text = str;
        
        NSInteger i = [dict[@"count_play"]integerValue];
        if (i > 10000) {
            cell.playCountsLabel.text =[NSString stringWithFormat:@"%.1lf万", (CGFloat)i/10000];
        }else {
            cell.playCountsLabel.text =[NSString stringWithFormat:@"%ld", i];
        }
        
        NSInteger time = [dict[@"duration"]integerValue];
        cell.soundFullTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
        
        cell.likesLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"count_like"]integerValue]];
        
        cell.commentLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"count_comment"]integerValue]];
        
        
        NSInteger time1 = [dict[@"updated_at"]integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time1/1000];
        cell.createTimeLabel.text = [CCMethod passedTimeSince:date];
        
        
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CCHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (self.index == 0) {
        if (section == 0) {
            view.sectionTitleLabel.text = @"专辑";
            view.sectionTitleLabel.font = [UIFont systemFontOfSize:15];
            NSString * str = [NSString stringWithFormat:@"全部条%ld结果", self.albumNum];
            view.sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [view.sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [view.sectionBtn setTitle:str forState:UIControlStateNormal];
            return view;
        }else if (section == 1) {
            view.sectionTitleLabel.text = @"声音";
            view.sectionTitleLabel.font = [UIFont systemFontOfSize:15];
            NSString * str = [NSString stringWithFormat:@"全部条%ld结果", self.soundNum];
            view.sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [view.sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [view.sectionBtn setTitle:str forState:UIControlStateNormal];
            return view;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.index == 0) {
        if (indexPath.section == 0) {
            NSArray * array = self.dataSource2[indexPath.section];
            NSDictionary * dict = array[indexPath.row];
            NSInteger i = [dict[@"id"] integerValue];
            CCAlbumDetailViewController * album = [[CCAlbumDetailViewController alloc] init];
            album.hidesBottomBarWhenPushed = YES;
            album.index = i;
            [self.navigationController pushViewController:album animated:YES];
        }else {
            NSArray * array = self.dataSource2[indexPath.section];
            NSDictionary * dict = array[indexPath.row];
            
            NSInteger trackId = [dict[@"id"] integerValue];
            NSInteger comment = [dict[@"count_comment"] integerValue];
            CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
            
            player.trackId = trackId;
            
            player.name = dict[@"title"];
            player.commentNum = comment;
            
            [self presentViewController:player animated:YES completion:^{
                
                CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
                playerBtn.hidden = YES;
                [player createPlayer];
                [player reloadData];
            }];
        }
    }else if (self.index == 1) {
        
        NSDictionary * dict = self.dataSource2[indexPath.row];
        NSInteger i = [dict[@"id"] integerValue];
        CCAlbumDetailViewController * album = [[CCAlbumDetailViewController alloc] init];
        album.hidesBottomBarWhenPushed = YES;
        album.index = i;
        [self.navigationController pushViewController:album animated:YES];
        
        
    }else if (self.index == 2) {
        NSDictionary * dict = self.dataSource2[indexPath.row];
        NSInteger trackId = [dict[@"id"] integerValue];
        NSInteger comment = [dict[@"count_comment"] integerValue];
        CCPlayerViewController * player = [CCPlayerViewController sharePlayerViewController];
        player.trackId = trackId;
        
        player.name = dict[@"title"];
        player.commentNum = comment;
        
        [self presentViewController:player animated:YES completion:^{
            CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
            playerBtn.hidden = YES;
            [player createPlayer];
            [player reloadData];
        }];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.index == 0) {
        return 40;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.index == 0) {
        if (section == 0) {
            return 10;
        }else if (section == 1) {
            return 130;
        }
    }
    return 130;
}

#pragma mark - segeVDelegate

- (void)reloadDataWithIndex:(NSInteger)index
{
    if (index == 0) {
        self.index = 0;
 

        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
        [self downloadData];
    }else if (index == 1) {
        self.index = 1;

        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
        [self downloadData2];
    }else if (index == 2) {
        self.index = 2;

        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
        [self downloadData3];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray * )dataSource2
{
    if (_dataSource2 == nil) {
        _dataSource2 = [[NSMutableArray alloc] init];
    }
    return _dataSource2;
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
