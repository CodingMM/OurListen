//
//  CCSegeView.m
//  ListenProject
//
//  Created by Elean on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCSegeView.h"
#import "CCGlobalHeader.h"
@implementation CCSegeView

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
    
    self.sege = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"专辑", @"声音"]];
    
    self.sege.frame = CGRectMake(10, 10, SCREEN_SIZE.width - 20, 30);
    self.sege.selectedSegmentIndex = 0;
    [self.sege addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventValueChanged];
    
    [view addSubview:self.sege];
    
    [self addSubview:view];
    
}
- (void)onClicked:(UISegmentedControl *)sege {
    
    NSInteger ind = sege.selectedSegmentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataWithIndex:)]) {
        [self.delegate reloadDataWithIndex:ind];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
