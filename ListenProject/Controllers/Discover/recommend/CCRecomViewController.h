//
//  CCRecomViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseTableViewController.h"

@protocol CCRecomViewControllerDelegate <NSObject>

- (void)setScrollViewContentOffSet:(CGPoint)index;

@end

@interface CCRecomViewController : CCBaseTableViewController

@property (nonatomic, weak) id<CCRecomViewControllerDelegate>delegate;

@end
