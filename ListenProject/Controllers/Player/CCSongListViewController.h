//
//  CCSongListViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import <UIKit/UIKit.h>



@interface CCSongListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (nonatomic, strong) NSMutableArray * songList;

@property (nonatomic, assign) NSInteger currentNum;





@end
