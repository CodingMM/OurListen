//
//  CCSoundCell.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CCSoundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundFullTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;




@end
