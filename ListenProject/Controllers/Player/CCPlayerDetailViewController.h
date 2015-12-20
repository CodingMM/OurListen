//
//  CCPlayerDetailViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCBaseViewController.h"

@interface CCPlayerDetailViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *jianjieLabel;
@property (weak, nonatomic) IBOutlet UILabel *geciLabel;


- (void)downloadDataWithTrackId:(NSInteger)trackId;


@end
