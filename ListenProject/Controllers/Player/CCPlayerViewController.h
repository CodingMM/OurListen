//
//  CCPlayerViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCBaseViewController.h"


@protocol CCPlayerViewControllerDelegate <NSObject>

- (void)reloadDataWithPlayerAlbumId:(NSInteger)albumId;

@end


@interface CCPlayerViewController : CCBaseViewController

@property(nonatomic, weak) id<CCPlayerViewControllerDelegate>delegate;
/**
 *  是否第一次播放
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


//直播时用的
@property (nonatomic, assign) NSInteger audioId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger programId;

@property (nonatomic, strong) NSDictionary * radioData;

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

+(CCPlayerViewController *)sharePlayerViewController;

- (void)createPlayer;

- (void)createAudioPlayer;

- (void)reloadData;

- (void)reloaddataWithCommentNum:(NSInteger)num andTrackID:(NSInteger)trackid;


@end
