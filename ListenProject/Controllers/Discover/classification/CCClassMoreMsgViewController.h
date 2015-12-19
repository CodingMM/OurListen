//
//  CCClassMoreMsgViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"

@protocol CCClassMoreMsgViewControllerDelegate <NSObject>

- (void)hiddenMsgView;

- (void)reloadDataWithCategory:(NSInteger)cate andPaiXu:(NSInteger)paixu;

@end

@interface CCClassMoreMsgViewController : CCBaseViewController

@property (nonatomic, weak) id <CCClassMoreMsgViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end
