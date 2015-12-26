//
//  CCAlbumSetDetailViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCAlbumSetDetailViewController : CCBaseViewController

@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger albumId;

@property (nonatomic, copy) NSString * titleL;

@end
