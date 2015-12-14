//
//  CCRecomCell.m
//  novelReader
//
//  Created by xiating on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCRecomCell.h"
#import "UIImageView+WebCache.h"


@interface CCRecomCell ()

@property (nonatomic, strong) id dataSource;

@end

@implementation CCRecomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDataWithData:(id)data
{
    self.dataSource = data;
    
    NSDictionary * item1 = self.dataSource[0];
    NSURL * url1 = [NSURL URLWithString:item1[@"coverLarge"]];
    [self.imageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage alloc]];
    
    self.imageView1.tag = [item1[@"albumId"] integerValue];
    self.imageView1.userInteractionEnabled = YES;
    [self addTapGesture:self.imageView1];
    self.label1.text = item1[@"trackTitle"];
    self.label12.text = item1[@"title"];
    
    NSDictionary * item2 = self.dataSource[1];
    NSURL * url2 = [NSURL URLWithString:item2[@"coverLarge"]];
    [self.imageView2 sd_setImageWithURL:url2 placeholderImage:[UIImage alloc]];
    self.imageView2.userInteractionEnabled = YES;
    self.imageView2.tag = [item2[@"albumId"] integerValue];
    [self addTapGesture:self.imageView2];
    self.label2.text = item2[@"trackTitle"];
    self.label22.text = item2[@"title"];
    
    NSDictionary * item3 = self.dataSource[2];
    NSURL * url3 = [NSURL URLWithString:item3[@"coverLarge"]];
    [self.imageView3 sd_setImageWithURL:url3 placeholderImage:[UIImage alloc]];
    self.imageView3.userInteractionEnabled = YES;
    self.imageView3.tag = [item3[@"albumId"] integerValue];
    [self addTapGesture:self.imageView3];
    self.label3.text = item3[@"trackTitle"];
    self.label32.text = item3[@"title"];
    
}
- (void)addTapGesture:(UIView *)view {
    
    UITapGestureRecognizer * ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [view addGestureRecognizer:ta];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(pushNextViewControllerWithUid:)]) {
        [_delegate pushNextViewControllerWithUid:tap.view.tag];
    }
}


@end
