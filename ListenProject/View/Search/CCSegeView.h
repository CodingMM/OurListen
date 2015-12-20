//
//  CCSegeView.h
//  ListenProject
//
//  Created by Elean on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSegeViewDelegate <NSObject>

- (void)reloadDataWithIndex:(NSInteger)index;

@end
@interface CCSegeView : UIView


@property (nonatomic, strong) UISegmentedControl * sege;

@property (nonatomic, weak) id <CCSegeViewDelegate> delegate;

@end
