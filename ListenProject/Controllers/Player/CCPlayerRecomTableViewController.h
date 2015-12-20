//
//  CCPlayerRecomTableViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerRecomendDelegate <NSObject>

- (void)reloadDataWithAlbumId:(NSInteger)albumId;

@end

@interface CCPlayerRecomTableViewController : UITableViewController


@property (nonatomic, weak) id <PlayerRecomendDelegate> delegate;

- (void)downloadDataWithTrackId:(NSInteger)trackId;

@end
