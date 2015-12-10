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

<<<<<<< HEAD
//请求语音详情
+ (NSURL *)getVoiceDetailWithTrackId:(NSString *)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求评论详情
+ (NSURL *)getCommentDetailWithTrackId:(NSString *)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求专辑
+ (NSURL *)getAlbumWithTrackId:(NSString *)trackId andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求专辑歌曲列表
+ (NSURL *)getAlbumSongsWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求分类详情
+ (NSURL *)getCategoryDetailWithTagName:(NSString *)tagName andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//请求分类列表
+ (NSURL *)getCategoryListWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取分类
+ (NSURL *)getCategoryWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取本地电台
+ (NSURL *)getLocalRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取国家电台
+ (NSURL *)getCountryRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取省电台
+ (NSURL *)getProvinceRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取网络电台
+ (NSURL *)getWedRadionWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取直播首页
+ (NSURL *)getLiveWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//没有找到
+ (NSURL *)getUnfindableWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取首页数据
+ (NSURL *)getMainDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;

//获取热门搜索数据
+ (NSURL *)getHotSearchDataWithSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;
=======

>>>>>>> origin/master

@end
