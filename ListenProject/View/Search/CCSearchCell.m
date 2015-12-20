//
//  CCSearchCell.m
//  ListenProject
//
//  Created by Elean on 15/12/20.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "CCSearchCell.h"
CGFloat heightForCell = 35;
@interface CCSearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation CCSearchCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = heightForCell / 2;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    _titleLabel.text = _keyword;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
}

- (CGSize)sizeForCell {
    //宽度加 heightForCell 为了两边圆角。
    return CGSizeMake([_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + heightForCell, heightForCell);
}

@end
