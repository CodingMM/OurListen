//
//  CCLiveDetailViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"
#import "CCGlobalHeader.h"
@interface CCLiveDetailViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) NSString * urlStr;

@property (nonatomic, copy) NSString * topTitle;

@property (nonatomic, assign) NSInteger radioType;



- (void)downloadData;

@end
