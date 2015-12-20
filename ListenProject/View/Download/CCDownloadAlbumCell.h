//
//  CCDownloadAlbumCell.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCDownloadAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



@end
