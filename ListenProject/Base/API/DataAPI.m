//
//  DataAPI.m
//  ListenProject
//
//  Created by Elean on 15/12/9.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "DataAPI.h"

@implementation DataAPI

#pragma mark -- 请求语音详情
+ (NSURL *)getVoiceDetailWithTrackId:(NSString *)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:VOICE_DETAIL_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
}

#pragma mark -- 请求评论详情
+ (NSURL *)getCommentDetailWithTrackId:(NSInteger)trackId andPageId:(NSInteger)pageId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:COMMENT_DETAIL_URL, trackId, pageId];
    
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 请求专辑
+ (NSURL *)getAlbumWithTrackId:(NSInteger)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:ALBUM_URL, trackId];
    
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
}

#pragma mark -- 请求专辑歌曲列表
+ (NSURL *)getAlbumSongsWithAlbumId:(NSInteger)albumId andPageNum:(NSInteger)pageNum andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:ALBUM_SONGS_URL, albumId, pageNum, albumId];
    
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
}

#pragma mark -- 请求分类详情
+ (NSURL *)getCategoryDetailWithTagName:(NSString *)tagName andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:tagName forKey:@"tagName"];
    
    return [BaseHttpClient httpType:GET andUrl:CATEGORY_DETAIL_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
}

#pragma mark -- 请求分类列表
+ (NSURL *)getCategoryListWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:CATEGORY_LIST_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
    
}

#pragma mark -- 获取分类
+ (NSURL *)getCategoryWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:GET_CATEGORY_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    
}

#pragma mark -- 获取本地电台
+ (NSURL *)getLocalRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:LOCAL_RADIO_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取国家电台
+ (NSURL *)getCountryRadionWithPageNum:(NSInteger)pageNumber andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:COUNTRY_RADIO_URL, pageNumber];
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取省电台
+ (NSURL *)getProvinceRadionWithPageNum:(NSInteger)pageNumber andCode:(NSString *)code andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:PROVINCE_RADIO_URL, code, pageNumber];
    
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取网络电台
+ (NSURL *)getWedRadionWithPageNum:(NSInteger)pageNumber andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:WEB_RADIO_URL, pageNumber];
    
    return [BaseHttpClient httpType:GET andUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取直播首页
+ (NSURL *)getLiveWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:LIVE_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 没有找到
+ (NSURL *)getUnfindableWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:UNFINDABLE_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取首页数据
+ (NSURL *)getMainDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:MAIN_DATA_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}

#pragma mark -- 获取热门搜索数据
+ (NSURL *)getHotSearchDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    return [BaseHttpClient httpType:GET andUrl:HOT_SEARCH_URL andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
}


@end
