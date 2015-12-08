//
//  LeftViewController.h
//  WYApp
//
//  Created by chen on 14-7-17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHBasicViewController.h"

@interface LeftViewController : QHBasicViewController

@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username; //账号
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *wxno;
@property (nonatomic, copy) NSString *idcardNO;
@property (nonatomic, assign) BOOL hasLogo;
@property (nonatomic, strong) UIImage *logoImage;


@end
