//
//  CCLiveCell1.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCLiveCell1.h"
#import "CCGlobalHeader.h"

@interface CCLiveCell1 ()

@property (nonatomic, strong) id dataSource;

@end


@implementation CCLiveCell1

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
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:item1[@"picPath"]]];
    self.imageView1.userInteractionEnabled = YES;
    self.imageView1.tag = [item1[@"radioId"] integerValue];
    [self addTapGesture:self.imageView1];
    self.titleLabel1.text = item1[@"rname"];
    
    NSDictionary * item2 = self.dataSource[1];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:item2[@"picPath"]]];
    self.imageView2.userInteractionEnabled = YES;
    self.imageView2.tag = [item2[@"radioId"] integerValue];
    [self addTapGesture:self.imageView2];
    self.titleLabel2.text = item2[@"rname"];
    
    NSDictionary * item3 = self.dataSource[2];
    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:item3[@"picPath"]]];
    self.imageView3.userInteractionEnabled = YES;
    self.imageView3.tag = [item3[@"radioId"] integerValue];
    [self addTapGesture:self.imageView3];
    self.titleLabel3.text = item3[@"rname"];
    
}

- (void)addTapGesture:(UIView *)view {
    
    UITapGestureRecognizer * ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [view addGestureRecognizer:ta];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(pushNextViewControllerWithRadioId:)]) {
        [_delegate pushNextViewControllerWithRadioId:tap.view.tag];
    }
}

@end
