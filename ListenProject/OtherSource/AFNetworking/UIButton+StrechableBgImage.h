//
//  UIButton+StrechableBgImage.h
//  SaveMachine
//
//  Created by Elean on 15/10/14.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (StrechableBgImage)
-(void)bgStrechableNormalImageName:(NSString *)normal HighlitedImageName:(NSString *)highlited Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y;

-(void)bgStrechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y;

-(void)strechableNormalImageName:(NSString *)normal HighlitedImageName:(NSString *)highlited Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y;

-(void)strechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y;


-(void)bgStrechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y;
@end
