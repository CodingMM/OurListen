//
//  CCSegmentedView.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCSegmentedView.h"
#import "CCGlobalHeader.h"
@implementation CCSegmentedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //定制view
        [self customView];
    }
    return self;
}


- (void)customView {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.sege = [[UISegmentedControl alloc] initWithItems:@[@"详情", @"评论", @"相关推荐"]];
    
    self.sege.frame = CGRectMake(10, 10, SCREEN_SIZE.width - 20, 30);
    self.sege.selectedSegmentIndex = 0;
    [self.sege addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventValueChanged];
    
    [view addSubview:self.sege];
    
    [self addSubview:view];
    
}

- (void)onClicked:(UISegmentedControl *)sege {
    
    NSInteger ind = sege.selectedSegmentIndex;

    if (_delegate != nil && [_delegate respondsToSelector:@selector(setBottomScrollViewContentOffSetWithIndex:)]) {
            [_delegate setBottomScrollViewContentOffSetWithIndex:ind];
        }
}

@end
