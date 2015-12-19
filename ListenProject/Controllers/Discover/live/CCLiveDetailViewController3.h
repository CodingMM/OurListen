//
//  CCLiveDetailViewController3.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCGlobalHeader.h"

@interface CCLiveDetailViewController3 : UIViewController



@property (nonatomic, copy) NSString * provinceId;

@property (nonatomic, strong) NSMutableArray * dataSource;

- (void)downloadData;

@end
