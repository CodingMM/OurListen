//
//  CCPlayerHeadViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCBaseViewController.h"

#import "CCGlobalHeader.h"

@protocol CCPlayerHeadViewControllerDelegate <NSObject>

- (void)reloadDataWithTrackId:(NSInteger)trackid andCommentNum:(NSInteger)num;

- (void)createHistoryView;

@end

@interface CCPlayerHeadViewController : CCBaseViewController

+ (CCPlayerHeadViewController *)sharedPlayerHeadViewController;


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *perImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengyinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fensiNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *programTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel2;


@property (nonatomic, strong) NSMutableArray * songList;

- (void)downloadDataWithAudioId:(NSInteger)audioId;
- (void)downloadDataWithAudioId2:(NSInteger)audioId;
- (void)downloadDataWithRadioData:(NSDictionary *)dict;

- (void)downloadDataWithTrackId:(NSInteger)trackId;
- (void)createDataWithPath:(NSString *)path andTrackId:(NSInteger)trackId;

@property (nonatomic, weak) id <CCPlayerHeadViewControllerDelegate> delegate;




@end
