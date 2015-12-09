//
//  UIView+trim.m
//  ProjectDemo
//
//  Created by Elean on 15/11/22.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import "NSString+category.h"
#import <CoreText/CoreText.h>

@implementation NSString(category)
- (NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



@end
