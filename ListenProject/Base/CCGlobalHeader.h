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
//屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

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


#define CURRENT_SONGNUMBER @"currentSongNumber"







#endif
