//
//  CCPlayerViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"


@protocol CCPlayerViewControllerDelegate <NSObject>

- (void)reloadDataWithPlayerAlbumId:(NSInteger)albumId;

@end


@interface CCPlayerViewController : CCBaseViewController

@property(nonatomic, weak) id<CCPlayerViewControllerDelegate>delegate;
/**
 *  播放次数
 */
@property (nonatomic, assign) NSInteger isFirstPlay;
/**
 *  歌曲列表
 */
@property (nonatomic, retain) NSMutableArray * songList;
/**
 * 曲目ID
 */
@property (nonatomic, assign) NSInteger trackId;
/**
 *  曲目名
 */
@property (nonatomic, copy) NSString * name;

/*
 
 */
@property (nonatomic, assign) NSInteger commentNum;


+(CCPlayerViewController *)sharePlayerViewController;

- (void)createPlayer;

- (void)createAudioPlayer;

- (void)reloadData;

- (void)reloaddataWithCommentNum:(NSInteger)num andTrackID:(NSInteger)trackid;


@end
