//
//  CCPlayerBtn.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCGlobalHeader.h"

#import "CCPlayerBtn.h"

@implementation CCPlayerBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        [self customButton];
    }
    return self;
}

-(void)customButton
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_normal"]];
    imageView.frame = CGRectMake(0, 0, SCREEN_SIZE.width/5, 65);
    
    self.imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_loop"]];
    self.imageView2.frame = CGRectMake(0, 0, 65, 65);
    self.imageView2.center = imageView.center;
    
    self.rotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LockScreen"]];
    self.rotationView.frame = CGRectMake(0, 0, 50, 50);
    self.rotationView.layer.cornerRadius = 25;
    self.rotationView.clipsToBounds = YES;
    self.rotationView.center = self.imageView2.center;
    
    [self addSubview:imageView];
    [self addSubview:self.imageView2];
    [self addSubview:self.rotationView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
