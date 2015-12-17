//
//  CCMethod.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCMethod.h"
/**
 *  通用工具类
 */

@implementation CCMethod

+ (NSString *)passedTimeSince:(NSDate *)date
{
    if (date == nil) {
        return @"没有记录";
    }
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [cal components:NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|kCFCalendarUnitMonth|kCFCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
    NSString *timeStr = [[NSString alloc]init];
    
    if (com.year >= 1) {
        timeStr = [NSString stringWithFormat:@"%ld年前",com.year];
    }else if (com.month >= 1) {
        timeStr = [NSString stringWithFormat:@"%ld月前",com.month];
    }else if(com.day>=1)
        timeStr = [NSString stringWithFormat:@"%ld天前",com.day];
    else if(com.hour>=1)
        timeStr = [NSString stringWithFormat:@"%ld小时前",com.hour];
    else if(com.minute >=1)
        timeStr = [NSString stringWithFormat:@"%ld分钟前",com.minute];
    else
        timeStr = [NSString stringWithFormat:@"%ld秒前",com.second];
    
    return timeStr;
}

@end
