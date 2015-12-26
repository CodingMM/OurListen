//
//  APPVersionCheck.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/26.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "APPVersionCheck.h"
#import "CCGlobalHeader.h"

@implementation APPVersionCheck

+(void)versionCheck:(void(^)(BOOL haveNew,NSURL *downloadUrl))handler
{
    NSError *error = nil;
    NSString * appInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:VERSION_CHECK] encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [appInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
    }else
    {
        NSArray *results = [dic objectForKey:@"results"];
        
        if(results.count == 0)
        {
            //没有app信息
            if (handler) {
                handler(NO,nil);
                return;
            }
            
        }else
        {
            
            NSDictionary * appInfoDic = results[0];
            CGFloat currentVersion = [[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
            NSString * versionStr = [appInfoDic objectForKey:@"version"];
            NSString *urlStr = [appInfoDic objectForKey:@"trackViewUrl"];
            CGFloat version = [versionStr floatValue];
            if (version > currentVersion) {
                NSURL *downloadUrl = [NSURL URLWithString:urlStr];
                
                if (handler) {
                    handler(YES,downloadUrl);
                }
            }else
            {
                if (handler) {
                    handler(NO,nil);
                }
            }
        }
    }

    
}

@end
