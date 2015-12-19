//
//  CCClassViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCClassViewController.h"
#import "CCGlobalHeader.h"
#import "CCClassCollectionViewCell.h"
#import "CCClassDetailViewController.h"

@interface CCClassViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CCClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CCCLASSCOLLECTIONCellID];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    [self downloadData];
}

- (void)downloadData {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=android&picVersion=10&scale=2" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = dict[@"list"];
        
        for (NSDictionary * dict in array) {
            [self.dataSource addObject:dict];
        }
    
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD dismissWithError:error.domain];
        NSLog(@"%@", error);
    }];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CCCLASSCOLLECTIONCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataSource[indexPath.item];
    NSURL * url = [NSURL URLWithString:dict[@"coverPath"]];
    [cell.cellImage sd_setImageWithURL:url];
    cell.cellTitle.text = dict[@"title"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCClassDetailViewController * vc = [[CCClassDetailViewController alloc] initWithNibName:@"CCClassDetailViewController" bundle:nil];
    vc.categoryId = [self.dataSource[indexPath.item][@"id"] integerValue];
    vc.cateTitle = self.dataSource[indexPath.item][@"title"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 15, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    CGFloat width = (SCREEN_SIZE.width - 1)/2.0f;
    return CGSizeMake(width, height);
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
