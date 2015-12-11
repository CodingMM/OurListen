//
//  CCBaseTableViewController.m
//  ListenProject
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "CCBaseTableViewController.h"

@implementation CCBaseTableViewController
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad{

    [super viewDidLoad];
    [self setUpAppDelegate];
    
    
}

- (void)setUpAppDelegate{

    self.appDelegate = [UIApplication sharedApplication].delegate;
}
@end
