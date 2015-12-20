//
//  CCDownloadManager.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCDownloadManager.h"


@interface CCDownloadManager ()

@end

@implementation CCDownloadManager

+ (CCDownloadManager *)sharedDownloadManager
{
    static CCDownloadManager * vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[CCDownloadManager alloc] init];
    });
    return vc;
}

+ (AFURLSessionManager *)sharedManager
{
    static AFURLSessionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return manager;
}


+ (void)downloadDataWithUrl:(NSString *)urlStr andTitle:(NSString *)title
{
    AFURLSessionManager * manager = [self sharedManager];
    manager.operationQueue.maxConcurrentOperationCount = 2;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    // 下载的方法
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString * path = NSHomeDirectory();
        NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
        
        path = [path stringByAppendingPathComponent:str];
        return [NSURL fileURLWithPath:path];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            // 续传时使用的信息
            NSData * resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = dict[@"正在下载"];
            
            for (NSMutableDictionary * dic in array) {
                if ([urlStr isEqualToString:dic[@"downloadUrl"]]) {
                    NSData * data = [resumeData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [dic setObject:data forKey:@"resumeData"];
                }
            }
            [dict writeToFile:path atomically:YES];
            
            NSInteger code = error.code;
            if (code == -1001) {
                NSLog(@"请求超时");
            }
            
        } else {
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = dict[@"正在下载"];
            NSMutableArray * array2 = dict[@"下载完成"];
            
            for (NSDictionary * dic in array) {
                if ([dic[@"downloadUrl"] isEqualToString:urlStr]) {
                    [array2 addObject:dic];
                }
            }
            for (NSDictionary * dic in array2) {
                [array removeObject:dic];
            }
            [dict setObject:array2 forKey:@"下载完成"];
            [dict setObject:array forKey:@"正在下载"];
            [dict writeToFile:path atomically:YES];
            
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"shuaxin" object:nil];
            
            
            NSLog(@"%@", NSHomeDirectory());
            NSLog(@"下载完成");
        }
        

    }];
    
    task.taskDescription = title;
    [task resume];

    
}

+ (NSArray *)downloadTasks {
    AFURLSessionManager * manager = [self sharedManager];
    return manager.downloadTasks;
}


+ (NSURLSessionDownloadTask *)downloadDataWithResumeData:(NSData *)resumeData andTitle:(NSString *)title {
    
    AFURLSessionManager * manager = [self sharedManager];
    
    // 续传的方法
    NSURLSessionDownloadTask * resumeTask = [manager downloadTaskWithResumeData:resumeData progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString * path = NSHomeDirectory();
        NSString * str = [NSString stringWithFormat:@"/Documents/%@.aac", title];
        path = [path stringByAppendingPathComponent:str];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            // 续传时使用的信息
            NSData * resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = dict[@"正在下载"];
            
            for (NSMutableDictionary * dic in array) {
                if ([title isEqualToString:dic[@"title"]]) {
                    NSData * data = [resumeData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [dic setObject:data forKey:@"resumeData"];
                }
            }
            [dict writeToFile:path atomically:YES];
            
            NSInteger code = error.code;
            if (code == -1001) {
                NSLog(@"请求超时");
            }
            
        } else {
            
            NSString * path = NSHomeDirectory();
            path = [path stringByAppendingPathComponent:@"/Documents/downloadArray.plist"];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            NSMutableArray * array = dict[@"正在下载"];
            NSMutableArray * array2 = dict[@"下载完成"];
            
            for (NSMutableDictionary * dic in array) {
                if ([dic[@"title"] isEqualToString:title]) {
                    [dic removeObjectForKey:@"resumeData"];
                    [array2 addObject:dic];
                }
            }
            for (NSDictionary * dic in array2) {
                [array removeObject:dic];
            }
            [dict setObject:array2 forKey:@"下载完成"];
            [dict setObject:array forKey:@"正在下载"];
            [dict writeToFile:path atomically:YES];
            
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"shuaxin" object:nil];
            
            
            NSLog(@"%@", NSHomeDirectory());
            NSLog(@"下载完成");
        }
        
        
    }];
    
    resumeTask.taskDescription = title;
    [resumeTask resume];
    
    
    return resumeTask;
}







@end
