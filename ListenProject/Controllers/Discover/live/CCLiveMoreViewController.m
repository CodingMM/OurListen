//
//  CCLiveMoreViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCLiveMoreViewController.h"
#import "CCLiveMoreCollectionCell.h"

@interface CCLiveMoreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, assign) NSInteger flag;

@end

@implementation CCLiveMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCLiveMoreCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCLiveMoreCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ItemCell2"];
    
    [self createDataSource];
    
}
- (void)createDataSource {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * array = dict[@"list"];
    
    self.dataSource = array;
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.flag == indexPath.item) {
        CCLiveMoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell2" forIndexPath:indexPath];
        cell.itemLabel.backgroundColor = [UIColor orangeColor];
        NSDictionary *itemData = self.dataSource[indexPath.item];
        cell.itemLabel.text = itemData[@"name"];
        cell.itemLabel.textColor = [UIColor whiteColor];
        cell.itemLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.itemLabel.layer.cornerRadius = 5;
        cell.itemLabel.clipsToBounds = YES;
        return cell;
    }else {
        
        CCLiveMoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
        NSDictionary *itemData = self.dataSource[indexPath.item];
        cell.itemLabel.text = itemData[@"name"];
        cell.itemLabel.layer.cornerRadius = 5;
        cell.itemLabel.clipsToBounds = YES;
        return cell;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.flag = indexPath.item;
    
    if ([self.delegate respondsToSelector:@selector(reloadDataWithProvinceId:)]) {
        [self.delegate reloadDataWithProvinceId:indexPath.item];
    }

    if ([self.delegate respondsToSelector:@selector(hiddenMsgView)]) {
        [self.delegate hiddenMsgView];
    }
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 15, 5, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 30.0f;
    CGFloat width = 60.0f;
    
    return CGSizeMake(width, height);
}


- (IBAction)backBtnDidClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hiddenMsgView)]) {
        [self.delegate hiddenMsgView];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
