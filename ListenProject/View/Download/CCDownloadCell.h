//
//  CCDownloadCell.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCDownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *songerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *downloadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;





@end
