//
//  YYLetfItemCell.h
//  TPSApp
//
//  Created by xiating on 15/6/3.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYLetfItemCell;
@protocol YYLetfItemCellDelegate <NSObject>

@optional
-(void)cellDidSelected:(YYLetfItemCell *)cell;

@end

@interface YYLetfItemCell : UITableViewCell

@property (nonatomic, retain) UIImageView *iconImage;
@property (nonatomic, retain) UILabel *itemL;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) id<YYLetfItemCellDelegate>delegate;

@end
