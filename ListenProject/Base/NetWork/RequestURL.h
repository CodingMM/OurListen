//
//  RequestURL.h
//  ListenProject
//
//  Created by Elean on 15/12/9.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#ifndef RequestURL_h
#define RequestURL_h

//服务器接口统一地址头
#define BASE_URL @""

//语音详情
#define VOICE_DETAIL_URL @"http://mobile.ximalaya.com/mobile/track/detail?trackId=%ld"

//评论详情
#define COMMENT_DETAIL_URL @"http://mobile.ximalaya.com/mobile/track/comment?trackId=%ld&pageSize=15&pageId=%ld"

//专辑
#define ALBUM_URL @"http://ar.ximalaya.com/rec-association/recommend/album?trackId=%ld"

//专辑歌曲列表
#define ALBUM_SONGS_URL @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/%ld/20?albumId=%ld&pageSize=20&isAsc=true&position=2"

//分类详情
#define CATEGORY_DETAIL_URL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%ld&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@"

//分类下的列表
#define CATEGORY_LIST_URL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/tagsWithoutCover?categoryId=%ld&contentType=album&device=android"

//获取分类
#define GET_CATEGORY_URL @"http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=android&picVersion=10&scale=2"

//本地电台
#define LOCAL_RADIO_URL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?provinceCode=110000&pageSize=15&pageNum=%ld&device=android&radioType=2"

//国家电台
#define COUNTRY_RADIO_URL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageSize=15&pageNum=%ld&device=android&radioType=1"

//省电台
#define PROVINCE_RADIO_URL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?provinceCode=%@&pageSize=15&pageNum=%ld&device=android&radioType=2"

//网络电台
#define WEB_RADIO_URL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageSize=15&pageNum=%ld&device=android&radioType=%ld"

//直播首页
#define LIVE_URL @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList"

//没找到
#define UNFINDABLE_URL @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList"

//首页数据
#define MAIN_DATA_URL @"http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=and-d10&device=android&includeActivity=true&includeSpecial=true&scale=2&version=4.3.14.3"

//热门搜索数据
#define HOT_SEARCH_URL @"http://mobile.ximalaya.com/s/hot_search_key?size=20&device=android"




#endif /* RequestURL_h */
