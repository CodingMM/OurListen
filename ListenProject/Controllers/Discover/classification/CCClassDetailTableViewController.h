//
//  CCClassDetailTableViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseTableViewController.h"
@protocol CCClassDetailTableViewControllerDelegate <NSObject>
- (void)pushToAlbumVCWithAlbumId:(NSInteger)albumId;

@end


@interface CCClassDetailTableViewController : UITableViewController
@property (nonatomic, weak) id <CCClassDetailTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDictionary * cateData;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, strong) NSMutableArray * dataSource;

- (void)downloadData;
- (void)relodaDataWithDataWithPaixu:(NSInteger)paixu;
@end
