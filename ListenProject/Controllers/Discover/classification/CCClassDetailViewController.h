//
//  CCClassDetailViewController.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import <UIKit/UIKit.h>



@interface CCClassDetailViewController : UIViewController


@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString * cateTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *bottonScrollView;







@end
