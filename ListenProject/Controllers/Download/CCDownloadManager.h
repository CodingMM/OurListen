//
//  CCDownloadManager.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CCDownloadManager : NSObject

+ (CCDownloadManager *)sharedDownloadManager;

+ (AFURLSessionManager *)sharedManager;

// 下载数据根据URL和Title
+ (void)downloadDataWithUrl:(NSString *)urlStr andTitle:(NSString *)title;

// 获取当前的下载队列
+ (NSArray *)downloadTasks;

// 下载数据根据以前下载留下的文件
+ (NSURLSessionDownloadTask *)downloadDataWithResumeData:(NSData *)resumeData andTitle:(NSString *)title;

@end
