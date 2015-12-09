//
//  ELNAlertView.h
//  CustomAlertView
//
//  Created by Elean on 15/11/16.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ELNAlertViewDelegate<NSObject>

- (void)selectedIndex:(NSInteger)index;

@end

@interface ELNAlertView : UIView




- (instancetype )initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<ELNAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)buttonTitles;



@end
