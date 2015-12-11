//
//  CCPlayerViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/10.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//

#import "CCPlayerViewController.h"
#import "CCPlayerBtn.h"
@interface CCPlayerViewController ()

@end

@implementation CCPlayerViewController
+(CCPlayerViewController *)sharePlayerViewController
{
    static CCPlayerViewController *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     
        playerVC = [[CCPlayerViewController alloc]initWithNibName:@"CCPlayerViewController" bundle:nil];
    });
    return playerVC;
}

#pragma mark - 创建播放器

-(void)createPlayer
{
    
}
-(void)createAudioPlayer
{
    
}
-(void)reloaddataWithCommentNum:(NSInteger)num andTrackID:(NSInteger)trackid
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
}
/**
 *  这是测试代码

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CCPlayerBtn *playerBtn = [CCPlayerBtn sharePlayerBtn];
    playerBtn.hidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
