//
//  DataAPI.h
//  ListenProject
//
//  Created by Elean on 15/12/9.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpClient.h"

@interface DataAPI : NSObject


//请求语音详情
+ (NSURL *)getVoiceDetailWithTrackId:(NSString *)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求评论详情
+ (NSURL *)getCommentDetailWithTrackId:(NSInteger)trackId andPageId:(NSInteger)pageId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求专辑
+ (NSURL *)getAlbumWithTrackId:(NSInteger)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求专辑歌曲列表
+ (NSURL *)getAlbumSongsWithAlbumId:(NSInteger)albumId andPageNum:(NSInteger)pageNum andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求分类详情
+ (NSURL *)getCategoryDetailWithTagName:(NSString *)tagName andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求分类列表
+ (NSURL *)getCategoryListWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取分类
+ (NSURL *)getCategoryWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取本地电台
+ (NSURL *)getLocalRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取国家电台
+ (NSURL *)getCountryRadionWithPageNum:(NSInteger)pageNumber andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取省电台
+ (NSURL *)getProvinceRadionWithPageNum:(NSInteger)pageNumber andCode:(NSString *)code andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取网络电台
+ (NSURL *)getWedRadionWithPageNum:(NSInteger)pageNumber andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取直播首页
+ (NSURL *)getLiveWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//没有找到
+ (NSURL *)getUnfindableWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取首页数据
+ (NSURL *)getMainDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取热门搜索数据
+ (NSURL *)getHotSearchDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;


@end
