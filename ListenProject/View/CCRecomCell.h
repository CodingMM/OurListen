//
//  CCRecomCell.h
//  novelReader
//
//  Created by xiating on 15/12/14.
//  Copyright (c) 2015年 夏婷. All rights
//

#import <UIKit/UIKit.h>

@protocol tableViewCell1Delegate <NSObject>

- (void)pushNextViewControllerWithUid:(NSInteger)index;

@end

@interface CCRecomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label12;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *label32;


@property id <tableViewCell1Delegate> delegate;

- (void)reloadDataWithData:(id)data;





@end
