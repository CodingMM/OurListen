//
//  ViewController.m
//  TableviewHeaderDemo
//
//  Created by Elean on 15/12/1.
//  Copyright (c) 2015年 Elean. All rights reserved.
//
/*
 总结：
 
 */

#import "ViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define COUNT 20

static CGFloat KImageOriginHight = 400 ;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIImageView * headImageheView;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * infoArray;


@end

@implementation ViewController
@synthesize headImageheView = _headImageheView;
@synthesize tableView = _tableView;
@synthesize infoArray = _infoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    [self reloadData];
    [self createHeaderView];
    
    
    
    
   }

#pragma mark -- create views

- (void)createTableView{

    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_W,SCREEN_H)];
    
    _tableView.delegate=self;
    
    _tableView.dataSource=self;
    
    _tableView.backgroundColor= [UIColor lightGrayColor];
    //内容由kImageOriginHight 处开始显示。
    
    _tableView.contentInset=UIEdgeInsetsMake(KImageOriginHight,0,0,0);
    
    
    [self.view addSubview:_tableView];
    
}

- (void)createHeaderView{

    _headImageheView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IMG_0154.JPG"]];
    
    _headImageheView.frame = CGRectMake(0, -KImageOriginHight, SCREEN_W, KImageOriginHight);
    
    [self.tableView addSubview:_headImageheView];
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
}


#pragma mark -- reloadData
- (void)reloadData{
    
    _infoArray = [NSMutableArray array];
    
    for(int i = 0 ; i < COUNT; i++){
    
        NSString * str = [NSString stringWithFormat:@"特工%.3d",i];
        [_infoArray addObject:str];
        
    }

    [self.tableView reloadData];
    
    [self.tableView reloadData];
    
    NSDictionary * userInfo = [NSDictionary dictionary];
    
    NSValue * value = [userInfo objectForKey:@"key"];
   
    
    
    
}

#pragma mark -- scrollView delegate



- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    /**
     *  关键处理：通过滚动视图获取到滚动偏移量从而去改变图片的变化
     */
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    
    CGFloat xOffset = (yOffset + KImageOriginHight)/2;
    
    if(yOffset <- KImageOriginHight) {
        
        CGRect f = self.headImageheView.frame;
        
        f.origin.y = yOffset ;
        
        f.size.height =  -yOffset;
        
        f.origin.x = xOffset;
        
        //int abs(int i); // 处理int类型的取绝对值
        //double fabs(double i); //处理double类型的取绝对值
        //float fabsf(float i); //处理float类型的取绝对值
        
        f.size.width = SCREEN_W + fabs(xOffset)*2;

        self.headImageheView.frame = f;
        
           }
   
   
    
}

#pragma mark -- dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"CellID";
    
    UITableViewCell * cell  =[self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text  = self.infoArray[indexPath.row];
    
    cell.textLabel.textColor = [UIColor purpleColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    
    return cell;
    
}
#pragma mark -- delegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
