//
//
//  CCAlbumModel.h
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "JSONModel.h"

@interface CCAlbumModel : JSONModel

@property (nonatomic, assign) NSInteger albumId;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSDictionary * dict;

@end
