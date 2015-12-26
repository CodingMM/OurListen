//
//  BaseHttpClient.m
//  ListenProject
//
//  Created by Elean on 15/12/9.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "BaseHttpClient.h"
#import "Reachability.h"

NSString * const kBaseServerUrlstring = BASE_URL;

static BaseHttpClient * sharaBaseHttpClient = nil;

@implementation BaseHttpClient
@synthesize baseURL = _baseURL;
@synthesize manager = _manager;
- (instancetype)initWithBaseUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        
        _baseURL = url;
     
       _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    return self;
}
+ (BaseHttpClient *)sharedClient{
    
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate, ^{
        
        sharaBaseHttpClient =  [[self alloc]initWithBaseUrl:BASE_URL];
        
    });
    
    return sharaBaseHttpClient;
    
}

+ (BOOL)isInternetEnable{

    return [[Reachability reachabilityForInternetConnection] isReachable];
}

+ (NSURL *)httpType:(BaseHttpType)requestType  andUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{
    
    if (![self isInternetEnable]) {
        
        
        
        BaseHttpClient * client = [BaseHttpClient sharedClient];
        
        NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
        
        signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL * returnURL = [NSURL URLWithString:signUrl];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络没有连接!"                                                                      forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:kBaseServerUrlstring code:999 userInfo:userInfo];
        
        errorHandler(returnURL, error);
        
        return returnURL;
    }
    
    if (requestType == GET) {
        
        return [BaseHttpClient httpGetWithUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
    }
    else if (requestType == POST){
        
        return [BaseHttpClient httpPostWithUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
        
        
    }
    else if (requestType == PUT){
        
        return [BaseHttpClient httpPutWithUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
        
    }else if (requestType == DELETE){
        
        return [BaseHttpClient httpPutWithUrl:url andParam:param andSuccessBlock:sucHandler andFailBlock:errorHandler];
        
        
    }
    
    
    
    
    return nil;
    
}
#pragma mark -- get
+ (NSURL *)httpGetWithUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{
    
    if ([ISNull isNilOfSender:url] == YES) {
        assert(@"request url is empty!");
        return nil;
    }
    
    BaseHttpClient * client = [BaseHttpClient sharedClient];
    
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
    
    signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    

    
    [client.manager GET:signUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([ISNull isNilOfSender:dict] == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"数据返回为空!"                                                                      forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:kBaseServerUrlstring code:999 userInfo:userInfo];
                
                errorHandler(returnURL, error);
            });
        }else{
        
            sucHandler(returnURL, dict);
        }
            
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(returnURL, error);
    }];
    
    
          return returnURL;
    
}


#pragma mark -- post
+ (NSURL *)httpPostWithUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{
    if ([ISNull isNilOfSender:url] == YES) {
        assert(@"request url is empty!");
        return nil;
    }
    
    BaseHttpClient * client = [BaseHttpClient sharedClient];
    
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
    
    signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    
    [client.manager POST:signUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([ISNull isNilOfSender:dict] == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"数据返回为空!"                                                                      forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:kBaseServerUrlstring code:999 userInfo:userInfo];
                
                errorHandler(returnURL, error);
            });
        }else{
            
            sucHandler(returnURL, dict);
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         errorHandler(returnURL, error);
    }];
    
    
    
    return returnURL;
    
    
    
}
#pragma mark -- put
+ (NSURL *)httpPutWithUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{
    if ([ISNull isNilOfSender:url] == YES) {
        assert(@"request url is empty!");
        return nil;
    }
    
    BaseHttpClient * client = [BaseHttpClient sharedClient];
    
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
    
    signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    
    [client.manager PUT:signUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([ISNull isNilOfSender:dict] == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"数据返回为空!"                                                                      forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:kBaseServerUrlstring code:999 userInfo:userInfo];
                
                errorHandler(returnURL, error);
            });
        }else{
            
            sucHandler(returnURL, dict);
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         errorHandler(returnURL, error);
    }];
    
    
    
    return returnURL;
    
}

#pragma mark -- delete
+ (NSURL *)httpDeleteWithUrl:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucHandler andFailBlock:(httpFailBlock)errorHandler{
    if ([ISNull isNilOfSender:url] == YES) {
        assert(@"request url is empty!");
        return nil;
    }
    
    BaseHttpClient * client = [BaseHttpClient sharedClient];
    
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
    
    signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    
    [client.manager DELETE:signUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([ISNull isNilOfSender:dict] == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"数据返回为空!"                                                                      forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:kBaseServerUrlstring code:999 userInfo:userInfo];
                
                errorHandler(returnURL, error);
            });
        }else{
            
            sucHandler(returnURL, dict);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(returnURL, error);
    }];
    
      
    return returnURL;
    
    
    
}
+ (void)cancelHTTPOperations{
    
    [[BaseHttpClient sharedClient].manager.operationQueue cancelAllOperations];
    
}


@end
