//
//  CCTableHeaderView.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCTableHeaderView.h"
#import "CCGlobalHeader.h"

@implementation CCTableHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_play_n_p"]];
        self.playImageView.frame = CGRectMake(0, 5, 30, 30);
        [self addSubview:self.playImageView];
        
        self.sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 30)];
        self.sectionTitleLabel.textColor = [UIColor orangeColor];
        self.sectionTitleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.sectionTitleLabel];
        
        self.sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sectionBtn.frame = CGRectMake(SCREEN_SIZE.width - 120, 10, 120, 20);
        [self addSubview:self.sectionBtn];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
