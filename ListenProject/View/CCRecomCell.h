//
//  CCRecomCell.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CCRecomCellDelegate <NSObject>

- (void)pushNextViewControllerWithUid:(NSInteger)index;

@end

@interface CCRecomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label12;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *label32;


@property id <CCRecomCellDelegate> delegate;

- (void)reloadDataWithData:(id)data;





@end
