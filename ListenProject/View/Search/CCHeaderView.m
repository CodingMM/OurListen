//
//  CCHeaderView.m
//  ListenProject
//
//  Created by Elean on 15/12/24.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "CCHeaderView.h"

@implementation CCHeaderView

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
        self.sectionBtn.frame = CGRectMake( - 120, 10, 120, 20);
        [self addSubview:self.sectionBtn];
    }
    
    return self;
}


@end
