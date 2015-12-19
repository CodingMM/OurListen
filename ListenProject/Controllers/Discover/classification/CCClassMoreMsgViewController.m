//
//  CCClassMoreMsgViewController.m
//  ListenProject
//
//  Created by 夏婷 on 15/12/19.
//  Copyright (c) 2015年 夏婷. All rights reserved.
//
#import "CCClassMoreMsgViewcontroller.h"
#import "CCGlobalHeader.h"
#import "CCClassMoreMsgCell.h"

@interface CCClassMoreMsgViewController ()<UITableViewDataSource,UITableViewDelegate,CCClassMoreMsgCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * source;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic, assign) NSInteger categoryNum;
@property (nonatomic, assign) NSInteger paixuNum;

@end

@implementation CCClassMoreMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.okBtn.layer.cornerRadius = 40;
    self.okBtn.clipsToBounds = YES;
    
    [self.source addObject:self.dataSource];
    
    NSArray * array = @[@{@"tname":@"最火"}, @{@"tname":@"最近更新"}, @{@"tname":@"经典"}];
    [self.source addObject:array];
    
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"CCClassMoreMsgCell" bundle:nil] forCellReuseIdentifier:CCCLASSMOREMSGCellID];
}


- (IBAction)shouBtnDidClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(hiddenMsgView)]) {
        [self.delegate hiddenMsgView];
    }
}


- (IBAction)okBtnDidClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(reloadDataWithCategory:andPaiXu:)]) {
        [self.delegate reloadDataWithCategory:self.categoryNum andPaiXu:self.paixuNum];
    }
    
    if ([self.delegate respondsToSelector:@selector(hiddenMsgView)]) {
        [self.delegate hiddenMsgView];
    }
}




#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.source.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.dataSource.count/3*40;
    }
    return 40;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CCClassMoreMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:CCCLASSMOREMSGCellID forIndexPath:indexPath];
        NSArray * array = self.source[indexPath.section];
        cell.delegate = self;
        [cell reloadWithData:array];
        return cell;
    }
    CCClassMoreMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:CCCLASSMOREMSGCellID forIndexPath:indexPath];
    NSArray * array = self.source[indexPath.section];
    cell.delegate = self;
    [cell reloadWithData:array];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.textColor = [UIColor orangeColor];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"类别";
    }else {
        label.text = @"排序";
    }
    return view;
}


- (void)recodeNumWithNum:(NSInteger)num andIndexPath:(NSIndexPath *)IndexPath
{
    if (num) {
        self.categoryNum = IndexPath.item;
    }else {
        self.paixuNum = IndexPath.item;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)source
{
    if (_source == nil) {
        _source = [[NSMutableArray alloc] init];
    }
    return _source;
}



@end
