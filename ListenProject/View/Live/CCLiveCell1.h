//
//  CCLiveCell1.h
//  ListenProject
//
//  Created by xiating on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CCLiveCell1Delegate <NSObject>

- (void)pushNextViewControllerWithRadioId:(NSInteger)radioId;

@end

@interface CCLiveCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (nonatomic, weak) id <CCLiveCell1Delegate> delegate;

- (void)reloadDataWithData:(id)data;


@end
