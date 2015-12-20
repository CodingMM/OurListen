//
//  CCSearchCell.h
//  ListenProject
//
//  Created by Elean on 15/12/20.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSearchCell : UICollectionViewCell

@property (nonatomic, copy) NSString *keyword;
- (CGSize)sizeForCell;

@end
