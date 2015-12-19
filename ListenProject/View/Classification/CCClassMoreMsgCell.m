//
//  CCClassMoreMsgCell.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCClassMoreMsgCell.h"
#import "CCGlobalHeader.h"
#import "CCMoreMsgCollectionCell.h"

@interface CCClassMoreMsgCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray * itemDataSource;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger flag1;

@end

@implementation CCClassMoreMsgCell

- (void)awakeFromNib {
    self.flag = -1;
    self.flag1 = 0;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCMoreMsgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCMoreMsgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ItemCell2"];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
}


- (void)reloadWithData:(id)data
{
    if([data count] > 3) {
        self.flag1 = 1;
    }
    [self.itemDataSource removeAllObjects];
    [self.itemDataSource addObjectsFromArray:data];
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.flag == indexPath.item) {
        CCMoreMsgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell2" forIndexPath:indexPath];
        cell.itemLabel.backgroundColor = [UIColor redColor];
        NSDictionary *itemData = self.itemDataSource[indexPath.item];
        cell.itemLabel.text = itemData[@"tname"];
        cell.itemLabel.layer.cornerRadius = 5;
        cell.itemLabel.clipsToBounds = YES;
        return cell;
    }else {
    
    CCMoreMsgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    NSDictionary *itemData = self.itemDataSource[indexPath.item];

    
    cell.itemLabel.text = itemData[@"tname"];
    cell.itemLabel.layer.cornerRadius = 5;
    cell.itemLabel.clipsToBounds = YES;
    return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.flag = indexPath.item;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(recodeNumWithNum:andIndexPath:)]) {
        [_delegate recodeNumWithNum:self.flag1 andIndexPath:indexPath];
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
    CGFloat width = 100.0f;
    
    return CGSizeMake(width, height);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//}


- (NSMutableArray *)itemDataSource
{
    if (_itemDataSource == nil) {
        _itemDataSource = [[NSMutableArray alloc] init];
    }
    
    return _itemDataSource;
}





@end
