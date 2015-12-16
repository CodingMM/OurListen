//
//  CCRecomCell2.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/16.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCRecomCell2.h"
#import "UIImageView+WebCache.h"

@interface CCRecomCell2 ()

@property (nonatomic, strong) id dataSource;

@end

@implementation CCRecomCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDataWithData:(id)data {
    
    self.dataSource = data;
    
    NSDictionary * item1 = self.dataSource[0];
    NSURL * url1 = [NSURL URLWithString:item1[@"coverPath"]];
    [self.imageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage alloc]];
    self.titleLabel1.text = item1[@"title"];
    self.detailLabel1.text = item1[@"subtitle"];
    self.numberLabel1.text = item1[@"footnote"];
    
}



@end
