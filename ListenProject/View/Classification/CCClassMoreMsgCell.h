//
//  CCClassMoreMsgCell.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CCClassMoreMsgCellDelegate <NSObject>

- (void)recodeNumWithNum:(NSInteger)num andIndexPath:(NSIndexPath *)IndexPath;

@end

@interface CCClassMoreMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger num;


@property (nonatomic, weak) id <CCClassMoreMsgCellDelegate> delegate;

- (void)reloadWithData:(id)data;

@end
