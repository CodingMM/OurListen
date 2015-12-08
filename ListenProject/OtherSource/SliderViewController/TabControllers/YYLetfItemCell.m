//
//  YYLetfItemCell.m
//  TPSApp
//
//  Created by xiating on 15/6/3.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYLetfItemCell.h"
#import "SliderViewControllerHeader.h"

@implementation YYLetfItemCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [UIFont fontNamesForFamilyName:@""];
        UIImage *image = [UIImage imageNamed:@"left_Order"];
        _iconImage = [[UIImageView alloc]initWithImage:image];
        _iconImage.frame = CGRectMake(30 *320/SCREEN_SIZE.width, (self.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
        [self.contentView addSubview:_iconImage];
        UIButton *selectBtn = [UIButton buttonWithType:0];
        selectBtn.frame = CGRectMake(0, -3, SCREEN_SIZE.width, 47);
        [selectBtn setImage:[UIImage imageNamed:@"leftCell_selected"] forState:UIControlStateHighlighted];
        [selectBtn addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
   
        [self addSubview:selectBtn];
        UIView *sepraterLine = [[UIView alloc]initWithFrame:CGRectMake(18 * 320/SCREEN_SIZE.width, self.frame.size.height, 215 * 320/SCREEN_SIZE.width - 0.25, 0.5)];
        sepraterLine.backgroundColor = [UIColor whiteColor];
        
        sepraterLine.alpha = 0.1f;
        [self.contentView addSubview:sepraterLine];
        _itemL = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.frame.origin.x + _iconImage.frame.size.width + 10, (self.frame.size.height - 30)/2, SCREEN_SIZE.width - (_iconImage.frame.origin.x + _iconImage.frame.size.width + 15) , 30)];
        _itemL.tintColor = [UIColor whiteColor];
        _itemL.font = [UIFont fontWithName:FountName size:12.4];;
        
        _itemL.textAlignment = NSTextAlignmentLeft;
       
        [self.contentView addSubview:_itemL];
        
    }
    return self;
}
-(void)cellClicked:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidSelected:)]) {
        [_delegate cellDidSelected:self];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
