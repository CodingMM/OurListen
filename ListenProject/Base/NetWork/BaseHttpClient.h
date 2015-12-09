//
//  BaseHttpClient.h
//  ListenProject
//
//  Created by Elean on 15/12/9.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "RequestURL.h"
#import "ISNull.h"

typedef enum:NSUInteger{
    
    GET = 1,
    POST,
    PUT,
    DELETE,
    
    
}BaseHttpType;


typedef void (^httpSuccessBlock)(NSURL *url,id data);
//请求成功的block
typedef void (^httpFailBlock)(NSURL *url, NSError * error);
//请求失败的block


@interface BaseHttpClient : NSObject


@property (nonatomic, strong) NSString * baseURL ;
//服务器的地址“头”

@property (nonatomic, strong)AFHTTPRequestOperationManager * manager;
//请求manager


+ (BaseHttpClient *)sharedClient;
//当前类的单例方法

+ (NSURL *)httpType:(BaseHttpType)requestType  andUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler;
//公共的请求方法

+ (void)cancelHTTPOperations;
//取消所以请求

@end
