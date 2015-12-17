//
//  CCAlbumDetailViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseTableViewController.h"


@protocol CCAlbumDetailViewControllerDelegate <NSObject>

- (void)reloadDataWithAlbumId:(NSInteger)albumId;


@end


@interface CCAlbumDetailViewController : CCBaseTableViewController

@property (nonatomic, weak) id<CCAlbumDetailViewControllerDelegate>delegate;

@end
