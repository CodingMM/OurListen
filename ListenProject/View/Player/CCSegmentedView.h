//
//  CCSegmentedView.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CCSegmentedViewDelegate <NSObject>

- (void)setBottomScrollViewContentOffSetWithIndex:(NSInteger)index;

@end

@interface CCSegmentedView : UIView

@property (nonatomic, strong) UISegmentedControl * sege;

@property (nonatomic, weak) id <CCSegmentedViewDelegate> delegate;

@end
