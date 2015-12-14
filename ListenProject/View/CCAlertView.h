//
//  CCAlertView.h
//  ListenProject
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CCAlertViewDelegate<NSObject>

- (void)selectedIndex:(NSInteger)index;

@end
@interface CCAlertView : UIView
- (instancetype )initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CCAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)buttonTitles;


@end
