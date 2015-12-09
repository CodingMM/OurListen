//
//  UIButton+StrechableBgImage.m
//  SaveMachine
//
//  Created by Elean on 15/10/14.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import "UIButton+StrechableBgImage.h"
#import "ISNull.h"
@implementation UIButton (StrechableBgImage)
-(void)bgStrechableNormalImageName:(NSString *)normal HighlitedImageName:(NSString *)highlited Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y
{
    if (title) {
        
        [self setTitle:title forState:UIControlStateNormal];
        
        //        [self setTitle:[Language get:title alter:nil] forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:highlited] == NO) {
        UIImage *highlitedImg = [UIImage imageNamed:highlited];
        highlitedImg = [highlitedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        
        [self setBackgroundImage:highlitedImg forState:UIControlStateHighlighted];
    }
}

-(void)bgStrechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:selected] == NO) {
        UIImage *selectedImg = [UIImage imageNamed:selected];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:selectedImg forState:UIControlStateSelected];
    }
    
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    
}

-(void)bgStrechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];
        [self setTitle:normalTitle forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:selected] == NO) {
        UIImage *selectedImg = [UIImage imageNamed:selected];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:selectedImg forState:UIControlStateSelected];
        [self setTitle:selectedTitle forState:UIControlStateNormal];
    }
    
    
    
}

-(void)strechableNormalImageName:(NSString *)normal HighlitedImageName:(NSString *)highlited Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        
        [self setImage:normalImg forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:highlited] == NO) {
        UIImage *highlitedImg = [UIImage imageNamed:highlited];
        highlitedImg = [highlitedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setImage:highlitedImg forState:UIControlStateHighlighted];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    
}

-(void)strechableNormalImageName:(NSString *)normal SelctedImageName:(NSString *)selected Title:(NSString *)title StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setImage:normalImg forState:UIControlStateNormal];
    }
    if ([ISNull isNilOfSender:selected] == NO) {
        UIImage *selectedImg = [UIImage imageNamed:selected];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setImage:selectedImg forState:UIControlStateSelected];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    
    
}

@end
