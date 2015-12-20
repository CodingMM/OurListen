//
//  CCPlayerDetailViewController.m
//  ListenProject
//
//  Created by xiating on 15/12/20.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//


#import "CCPlayerDetailViewController.h"
#import "CCGlobalHeader.h"

@interface CCPlayerDetailViewController ()

@end

@implementation CCPlayerDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadDataWithTrackId:(NSInteger)trackId {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/track/detail?trackId=%ld", trackId];
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (json[@"intro"] == nil) {
            self.jianjieLabel.hidden = YES;
        }
        NSString * str = json[@"intro"];
        self.jianjieLabel.text = str;
        
        if (json[@"lyric"] == nil) {
            [self.geciLabel setHidden:YES];
        }
        NSString * str2 = json[@"lyric"];
        self.geciLabel.text = str2;
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



@end
