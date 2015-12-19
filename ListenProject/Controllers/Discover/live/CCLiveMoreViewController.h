//
//  CCLiveMoreViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCLiveMoreViewControllerDelegate <NSObject>

- (void)reloadDataWithProvinceId:(NSInteger)provinceId;
- (void)hiddenMsgView;

@end

@interface CCLiveMoreViewController : UIViewController

@property (nonatomic, weak) id <CCLiveMoreViewControllerDelegate> delegate;

@end
