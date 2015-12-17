//
//  CCHeadViewController.h
//  ListenProject
//
//  Created by 夏婷 on 15/12/17.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCBackBtnDelegate <NSObject>

- (void)popBeforeViewController;

@end

@interface CCHeadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (nonatomic, weak) id <CCBackBtnDelegate> delegate;

- (void)reloadDataWithDictory:(NSDictionary *)dict;

@end
