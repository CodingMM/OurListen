//
//  CCPlayerHeadViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCPlayerHeadViewController.h"
#import "CCPlayerViewController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "CCSongListViewController.h"
#import "CCGlobalHeader.h"
#import "CCHistoryViewController.h"
#import "CCPlayerBtn.h"
#import "UIImageAnimation.h"

NSInteger i = 0;
BOOL isPlaying = NO;

NSInteger type = 0;

@interface CCPlayerHeadViewController ()

@property (nonatomic, strong) AVPlayer * audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;


@property (nonatomic, strong) NSMutableArray * audioPlayerItemArray;

@property (nonatomic, strong) AVPlayerItem * item;

@end

@implementation CCPlayerHeadViewController


+ (CCPlayerHeadViewController *)sharedPlayerHeadViewController
{
    static CCPlayerHeadViewController * vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[CCPlayerHeadViewController alloc] initWithNibName:@"CCPlayerHeadViewController" bundle:nil];
    });
    return vc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    self.slider.minimumTrackTintColor = [UIColor orangeColor];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated{

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [super viewDidDisappear:animated];
}


#pragma mark - buttonDidClicked

- (IBAction)sliderValueChanger:(id)sender {
    [self.audioPlayer pause];
    CMTime totalTime = self.audioPlayer.currentItem.duration;
    float totalSeconds = totalTime.value * 1.0f/ totalTime.timescale;
    float currentSeconds = totalSeconds * self.slider.value;
    CMTime currentTime = CMTimeMake(currentSeconds * totalTime.timescale, totalTime.timescale);
    [self.audioPlayer seekToTime:currentTime];
    
    
}

- (IBAction)TouchCancle:(id)sender {
    if (isPlaying == NO) {
        [self.audioPlayer pause];
    }else {
        [self.audioPlayer play];
    }
}




- (IBAction)backBtnDidClicked:(id)sender {
    
    [[CCPlayerViewController sharePlayerViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)listBtnDidClicked:(id)sender {
    
    CCSongListViewController * songList = [[CCSongListViewController alloc] initWithNibName:@"CCSongListViewController" bundle:nil];
    songList.songList = self.songList;

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [[defaults objectForKey:CURRENT_SONGNUMBER] integerValue];
    songList.currentNum = num;
    
    [[CCPlayerViewController sharePlayerViewController] presentViewController:songList animated:YES completion:nil];
    
}
- (IBAction)beforeBtnDidClicked:(id)sender {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [[defaults objectForKey:CURRENT_SONGNUMBER] integerValue];

    if (num > 0) {
        
        NSDictionary * dict = self.songList[--num];
        NSInteger trackid = [dict[@"trackId"] integerValue];
        NSInteger comment = [dict[@"comments"] integerValue];
        [defaults setObject:@(trackid) forKey:@"trackid"];
        [defaults setObject:@(comment) forKey:@"comment"];
        
        [defaults setObject:@(num) forKey:CURRENT_SONGNUMBER];
        
        [defaults synchronize];
        
        NSFileManager * fm = [NSFileManager defaultManager];
        NSString * title = dict[@"title"];
        NSString * path1 = NSHomeDirectory();
        NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
        path1 = [path1 stringByAppendingPathComponent:str];
        
        if ([fm fileExistsAtPath:path1]) {
            
            NSURL * url = [NSURL fileURLWithPath:path1];
            
            AVPlayerItem * playI = [[AVPlayerItem alloc] initWithURL:url];
            [self.audioPlayer replaceCurrentItemWithPlayerItem:playI];
            [self createDataWithPath:path1 andTrackId:trackid];
        }else {
            AVPlayerItem * playI = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:dict[@"playUrl32"]]];
            [self.audioPlayer replaceCurrentItemWithPlayerItem:playI];
            [self downloadDataWithTrackId:trackid];
        }
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadDataWithTrackId:andCommentNum:)]) {
            [_delegate reloadDataWithTrackId:trackid andCommentNum:comment];
        }
    }
}
- (IBAction)playBtnDidClicked:(id)sender {
    if (isPlaying == NO) {
        [self.audioPlayer play];
        [self.playBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
        [self start];
        isPlaying = YES;
    }else {
        [self.audioPlayer pause];
        [self.playBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        [self stop];
        isPlaying = NO;
    }
}

- (void)start
{
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.animation9 = [UIImageAnimation rotation:1 degree:30 direction:-1 repeatCount:1000000];
    [playerBtn.rotationView.layer addAnimation:playerBtn.animation9 forKey:nil];
}

- (void)stop
{
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.animation9 = [UIImageAnimation rotation:1 degree:0 direction:-1 repeatCount:0];
    [playerBtn.rotationView.layer addAnimation:playerBtn.animation9 forKey:nil];
}


- (IBAction)nextBtnDidClicked:(id)sender {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [[defaults objectForKey:CURRENT_SONGNUMBER] integerValue];
    

    if (num < self.songList.count - 1) {
        
        NSDictionary * dict = self.songList[++num];
        NSInteger trackid = [dict[@"trackId"] integerValue];
        NSInteger comment = [dict[@"comments"] integerValue];
        
        [defaults setObject:@(num) forKey:CURRENT_SONGNUMBER];
        [defaults setObject:@(trackid) forKey:@"trackid"];
        [defaults setObject:@(comment) forKey:@"comment"];
        [defaults synchronize];
        
        
        NSFileManager * fm = [NSFileManager defaultManager];
        NSString * title = dict[@"title"];
        NSString * path1 = NSHomeDirectory();
        NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
        path1 = [path1 stringByAppendingPathComponent:str];
        
        if ([fm fileExistsAtPath:path1]) {
            
            NSURL * url = [NSURL fileURLWithPath:path1];

            AVPlayerItem * playI = [[AVPlayerItem alloc] initWithURL:url];
            [self.audioPlayer replaceCurrentItemWithPlayerItem:playI];
            [self createDataWithPath:path1 andTrackId:trackid];
        }else {
            AVPlayerItem * playI = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:dict[@"playUrl32"]]];
            [self.audioPlayer replaceCurrentItemWithPlayerItem:playI];
            [self downloadDataWithTrackId:trackid];
        }
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadDataWithTrackId:andCommentNum:)]) {
            [_delegate reloadDataWithTrackId:trackid andCommentNum:comment];
        }
    }

}
- (IBAction)historyBtnDidClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(createHistoryView)]) {
        [self.delegate createHistoryView];
    }
}


#pragma mark - Helper Methods


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 当播放器缓冲好了之后，只会走一次，
    if (self.audioPlayer.status == AVPlayerStatusReadyToPlay) {
        NSLog(@"缓冲好了");
        [self playBtnDidClicked:self.playBtn];
    }
    
}

- (void)createDataWithPath:(NSString *)path andTrackId:(NSInteger)trackId {
    type = 1;
    if (type == 1) {
        self.currentTimeLabel2.hidden = YES;
        self.currentTimeLabel.hidden = NO;
    }
    NSString * path1 = NSHomeDirectory();
    path1 = [path1 stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path1];
    NSMutableArray * array = dict[@"下载完成"];
    for (NSDictionary * dic in array) {
        if ([dic[@"trackId"]integerValue] == trackId) {
            [self createDetailWithDict:dic];
            [self createHistoryArray:dic];
        }
    }
    
    NSURL * url = [NSURL fileURLWithPath:path];
    self.item = [[AVPlayerItem alloc] initWithURL:url];

    
    [self.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    __weak CCPlayerHeadViewController * weakSelf = self;
    
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(0.1*30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

        
        float playSeconds = weakSelf.audioPlayer.currentTime.value * 1.0f/weakSelf.audioPlayer.currentTime.timescale;
        
        float totalSeconds = (weakSelf.audioPlayer.currentItem.duration.value * 1.0f/ weakSelf.audioPlayer.currentItem.duration.timescale);
        weakSelf.slider.value = playSeconds / totalSeconds;
        
        weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld  /  %02ld:%02ld", (NSInteger)playSeconds/60, (NSInteger)playSeconds%60, (NSInteger)totalSeconds/60, (NSInteger)totalSeconds%60];

        
        if (weakSelf.slider.value > 0.99) {
            [weakSelf nextBtnDidClicked:weakSelf.nextBtn];
        }
        
    }];
    
}




- (void)downloadDataWithTrackId:(NSInteger)trackId
{
    type = 1;
    if (type == 1) {
        self.currentTimeLabel2.hidden = YES;
        self.currentTimeLabel.hidden = NO;
    }
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack networkIndicator:YES];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/track/detail?trackId=%ld", trackId];
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        [self createHistoryArray:json];
        
        self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:json[@"playUrl32"]]];
        
        [self.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

        
        __weak CCPlayerHeadViewController * weakSelf = self;
        
        [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(0.1*30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float playSeconds = weakSelf.audioPlayer.currentTime.value * 1.0f/weakSelf.audioPlayer.currentTime.timescale;
            
            float totalSeconds = (weakSelf.audioPlayer.currentItem.duration.value * 1.0f/ weakSelf.audioPlayer.currentItem.duration.timescale);
            
            weakSelf.slider.value = playSeconds / totalSeconds;
            
            weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld  /  %02ld:%02ld", (NSInteger)playSeconds/60, (NSInteger)playSeconds%60, (NSInteger)totalSeconds/60, (NSInteger)totalSeconds%60];
            
            if (weakSelf.slider.value > 0.99) {
                [weakSelf nextBtnDidClicked:weakSelf.nextBtn];
            }
            
        }];
        
        [self createDetailWithDict:json];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)downloadDataWithAudioId:(NSInteger)audioId
{
    type = 2;
    if (type == 2) {
        self.currentTimeLabel2.hidden = NO;
        self.currentTimeLabel.hidden = YES;
        self.programTitleLabel.hidden = NO;
        self.playTimeLabel.hidden = NO;
        self.mainImageView.hidden = YES;
        self.nextBtn.enabled = NO;
        self.beforeBtn.enabled = NO;
        self.slider.enabled = NO;
        self.historyBtn.enabled = NO;
        self.listBtn.enabled = NO;
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList";
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = json[@"result"][@"recommandRadioList"];
        
        for (NSDictionary * dict in array) {
            if ([dict[@"radioId"]integerValue] == audioId) {

                
                [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"picPath"]]];
                
                self.titleLabel.text = dict[@"rname"];
                self.programTitleLabel.text = dict[@"programName"];
                self.playTimeLabel.text = [NSString stringWithFormat:@"%@~%@", dict[@"startTime"], dict[@"endTime"]];
                [self.perImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"picPath"]]];
                
                
                CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
                [playerBtn.rotationView sd_setImageWithURL:[NSURL URLWithString:dict[@"picPath"]]];
                
                
                
                self.topTitleLabel.text = dict[@"rname"];
                self.detailLabel.text = dict[@"programName"];
                
                
                NSDictionary * dic = dict[@"radioPlayUrl"];
                self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:dic[@"radio_24_aac"]]];
                
                [self.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
                
                
                __weak CCPlayerHeadViewController * weakSelf = self;
                
                [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(0.1*30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                    float playSeconds = weakSelf.audioPlayer.currentTime.value * 1.0f/weakSelf.audioPlayer.currentTime.timescale;
                    
                    float totalSeconds = (weakSelf.audioPlayer.currentItem.duration.value * 1.0f/ weakSelf.audioPlayer.currentItem.duration.timescale);
                    
                    weakSelf.slider.value = playSeconds / totalSeconds;
                    
                    weakSelf.currentTimeLabel2.text = [weakSelf getTime];


                }];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}

- (NSString *)getTime {
    
    NSDate * date = [NSDate date];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"H:mm:ss"];
    NSString * str1 = [df stringFromDate:date];
    return str1;
}

- (void)downloadDataWithAudioId2:(NSInteger)audioId
{
    type = 2;
    if (type == 2) {
        self.currentTimeLabel2.hidden = NO;
        self.currentTimeLabel.hidden = YES;
        self.programTitleLabel.hidden = NO;
        self.playTimeLabel.hidden = NO;
        self.mainImageView.hidden = YES;
        self.nextBtn.enabled = NO;
        self.beforeBtn.enabled = NO;
        self.slider.enabled = NO;
        self.historyBtn.enabled = NO;
        self.listBtn.enabled = NO;
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList";
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = json[@"result"][@"topRadioList"];
        
        for (NSDictionary * dict in array) {
            if ([dict[@"radioId"]integerValue] == audioId) {

                
                [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverLarge"]]];
                self.titleLabel.text = dict[@"rname"];
                self.programTitleLabel.text = dict[@"programName"];

                CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
                [playerBtn.rotationView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverSmall"]]];
                
                
                
                [self.perImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverSmall"]]];
                self.topTitleLabel.text = dict[@"rname"];
                self.detailLabel.text = dict[@"programName"];
                
                
                NSDictionary * dic = dict[@"radioPlayUrl"];
                self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:dic[@"radio_24_aac"]]];
                
                
                [self.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
                
                
                __weak CCPlayerHeadViewController * weakSelf = self;
                
                [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(0.1*30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                    float playSeconds = weakSelf.audioPlayer.currentTime.value * 1.0f/weakSelf.audioPlayer.currentTime.timescale;
                    
                    float totalSeconds = (weakSelf.audioPlayer.currentItem.duration.value * 1.0f/ weakSelf.audioPlayer.currentItem.duration.timescale);
                    
                    weakSelf.slider.value = playSeconds / totalSeconds;
                    
                    weakSelf.currentTimeLabel2.text = [weakSelf getTime];
                    
                    
                }];
                
                
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getProgramDetail?radioId=%ld&device=android", audioId];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * dict = json[@"result"];
        
        self.playTimeLabel.text = [NSString stringWithFormat:@"%@~%@", dict[@"startTime"], dict[@"endTime"]];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}


- (void)downloadDataWithRadioData:(NSDictionary *)dict
{
    type = 2;
    if (type == 2) {
        self.currentTimeLabel2.hidden = NO;
        self.currentTimeLabel.hidden = YES;
        self.programTitleLabel.hidden = NO;
        self.playTimeLabel.hidden = NO;
        self.mainImageView.hidden = YES;
        self.nextBtn.enabled = NO;
        self.beforeBtn.enabled = NO;
        self.slider.enabled = NO;
        self.historyBtn.enabled = NO;
        self.listBtn.enabled = NO;
    }
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverLarge"]]];
    self.titleLabel.text = dict[@"rname"];
    self.programTitleLabel.text = dict[@"programName"];
    
    CCPlayerBtn *palyerBtn = [CCPlayerBtn sharePlayerBtn];
    [palyerBtn.rotationView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverSmall"]]];
    
    
    
    [self.perImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"radioCoverSmall"]]];
    self.topTitleLabel.text = dict[@"rname"];
    self.detailLabel.text = dict[@"programName"];
    
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@~%@", dict[@"startTime"], dict[@"endTime"]];
    
    NSDictionary * dic = dict[@"radioPlayUrl"];
    self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:dic[@"radio_24_aac"]]];

    [self.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    __weak CCPlayerHeadViewController * weakSelf = self;
    
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(0.1*30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float playSeconds = weakSelf.audioPlayer.currentTime.value * 1.0f/weakSelf.audioPlayer.currentTime.timescale;
        
        float totalSeconds = (weakSelf.audioPlayer.currentItem.duration.value * 1.0f/ weakSelf.audioPlayer.currentItem.duration.timescale);
        
        weakSelf.slider.value = playSeconds / totalSeconds;
        
        weakSelf.currentTimeLabel2.text = [weakSelf getTime];
        
        
    }];

}



- (void)createDetailWithDict:(NSDictionary *)json {
    
    self.programTitleLabel.hidden = YES;
    self.playTimeLabel.hidden = YES;
    self.mainImageView.hidden = NO;
    self.slider.enabled = YES;
    self.nextBtn.enabled = YES;
    self.beforeBtn.enabled = YES;
    self.historyBtn.enabled = YES;
    self.listBtn.enabled = YES;
    
    self.topTitleLabel.text = json[@"title"];
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:json[@"coverLarge"]]];
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:json[@"coverMiddle"]]];
    self.mainImageView.layer.cornerRadius = self.mainImageView.frame.size.width/4;
    self.mainImageView.clipsToBounds = YES;
    
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    [playerBtn.rotationView sd_setImageWithURL:[NSURL URLWithString:json[@"coverMiddle"]]];
    
    [self.perImageView sd_setImageWithURL:[NSURL URLWithString:json[@"userInfo"][@"smallLogo"]]];
    self.perImageView.layer.cornerRadius = 30;
    self.perImageView.clipsToBounds = YES;
    
    
    self.titleLabel.text = json[@"userInfo"][@"nickname"];
    
    
    NSInteger num2 = [json[@"userInfo"][@"tracks"] integerValue];
    self.shengyinNumberLabel.text = [NSString stringWithFormat:@"%ld", num2];
    
    NSInteger num3 = [json[@"userInfo"][@"followers"] integerValue];
    if (num3 > 10000) {
        self.fensiNumberLabel.text = [NSString stringWithFormat:@"%.1lf万", (CGFloat)num3/10000];
    }else {
        self.fensiNumberLabel.text = [NSString stringWithFormat:@"%ld", num3];
    }
    
    self.detailLabel.text = json[@"userInfo"][@"ptitle"];
}

- (void)createHistoryArray:(NSDictionary *)json {
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"/Documents/historyArray.plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [dict setObject:array1 forKey:@"浏览历史"];
        [dict writeToFile:path atomically:YES];
    }
    NSMutableArray * array = dict[@"浏览历史"];
    if (array.count == 0) {
        [array addObject:json];
        [dict setObject:array forKey:@"浏览历史"];
        [dict writeToFile:path atomically:YES];
        return;
    }else {
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary * dict2 = array[i];
            if (dict2[@"trackId"] == json[@"trackId"]) {
                [array removeObject:dict2];
                [array insertObject:dict2 atIndex:0];
                [dict setObject:array forKey:@"浏览历史"];
                [dict writeToFile:path atomically:YES];
                return;
            }
        }
        [array insertObject:json atIndex:0];
        [dict setObject:array forKey:@"浏览历史"];
        [dict writeToFile:path atomically:YES];
    }
}


- (NSMutableArray *)audioPlayerItemArray
{
    if (_audioPlayerItemArray == nil) {
        _audioPlayerItemArray = [[NSMutableArray alloc] init];
    }
    return _audioPlayerItemArray;
}


- (AVPlayer *)audioPlayer
{
    if (_audioPlayer == nil) {
        _audioPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }else {
        [_audioPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    return _audioPlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
