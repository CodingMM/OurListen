//
//  CCGlobalHeader.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#ifndef ListenProject_CCGlobalHeader_h

#import "AFHTTPSessionManager.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#define ListenProject_CCGlobalHeader_h

//版本检测相关
//test 1067742723

//product  1070849223
#define VERSION_CHECK @"https://itunes.apple.com/lookup?id=1067742723"

//屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

//状态栏颜色
#define STATUS_COLOR [UIColor colorWithRed:254/255.f green:138/255.f blue:114/255.f alpha:1]
//254 138 114

//专辑cell
#define CCAlbumCellID @"CCAlbumCell"
//推荐列表cell
#define CCRECOMCellID1 @"CCRecomCell1"
#define CCRECOMCellID2 @"CCRecomCell2"
#define CCRECOMCellID3 @"CCRecomCell3"
#define CCRECOMCellID4 @"CCRecomCell4"


//听单列表
#define CCLISTENCell1ID @"ListenListTableViewCell1"
#define CCLISTENCell2ID @"ListenListTableViewCell2"
#define CCLISTENCell3ID @"ListenListTableViewCell3"
#define CCLISTENCell4ID @"ListenListTableViewCell4"

//分类列表

#define CCCLASSRECOMCellID @"CCClassRecomCell"
#define CCCLASSMOREMSGCellID @"CCClassMoreMsgCell"
#define CCCLASSCOLLECTIONCellID @"CCClassCollectionViewCell"


//直播列表
#define CCLIVECell1ID @"CCLiveCell1"
#define CCLIVECell2ID @"CCLiveCell2"


//播放历史

#define CCHISTORYCellID @"CCHistoryCell"

#define CCPLAYERCOMMONCellID @"CCPlayerCommonCell"
#define CCPLAYERRECOMCellID  @"CCPlayerRecomCell"

//下载

#define CCDOWNLOADCellID @"CCDownloadCell"

#define CCSOUNDCellID @"CCSoundCell"

#define CCSORTCellID @"CCSortCell"

#define CCDOWNLOADALBUMCELLID @"CCDownloadAlbumCell"




#define CURRENT_SONGNUMBER @"currentSongNumber"






#endif
