//
//  APPVersionCheck.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/26.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPVersionCheck : NSObject
+(void)versionCheck:(void(^)(BOOL haveNew,NSURL *downloadUrl))handler;
@end
