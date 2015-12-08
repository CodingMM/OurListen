//
//  LeftViewController.m
//  WYApp
//
//  Created by chen on 14-7-17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "LeftViewController.h"
#import "SliderViewController.h"
#import "YYLetfItemCell.h"
#import "UIView+KGViewExtend.h"
#import "SliderViewControllerHeader.h"
#import "QHCommonUtil.h"
/*
#import "YYMyOrderListController.h"
#import "MyAccountViewController.h"
#import "YYSetViewController.h"
#import "YYBudgetListController.h"
#import "YYQuickPayCardsController.h"
#import "YYContacterController.h"
 */

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate,YYLetfItemCellDelegate>{
    NSMutableArray *_arData;
    NSDictionary *_dicData;
    UITableView *_tableView;
    UILabel *nameL;
    UILabel *companyL;
}
@property (nonatomic, strong) NSURLSessionDataTask *getInfoTask;
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
@end

@implementation LeftViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePersonalInformation" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
 
}
- (void)viewDidLoad{
    
    
    [self addObserver];
    
    _arData = [[NSMutableArray alloc]initWithObjects:@[@"机票订单", @"left_Order"],@[@"常用联系人", @"left_Contacter"], nil];
        [_arData addObject: @[@"快捷支付", @"left_Quickpay"]];
//    [_arData addObject:@[@"预算", @"left_Budget"]];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView *bagroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftView_background"]];
    bagroundImage.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [self.view addSubview:bagroundImage];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
     [self addPersonalInfo];
    float hHeight = 90;
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4 + 10)];
    imageBgV.tag = 18;
    [self.view addSubview:imageBgV];
    
    hHeight = imageBgV.bottom - 80;
    UIImageView *imageBgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, hHeight, self.view.width, self.view.height - hHeight)];
    imageBgV2.tag = 19;
    [imageBgV2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageBgV2];
    

    NSLog(@"%f", _contentView.layer.anchorPoint.x);
    
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 60, 70, 70)];
    headerIV.layer.cornerRadius = headerIV.width/2;
    headerIV.tag = 20;
    [_contentView addSubview:headerIV];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imageBgV.bottom + 10, self.view.width, self.view.height - imageBgV.bottom - 80) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];
    
    [self addSettingBtn];
    
    [self reloadImage];
}

- (void)backAction:(UIButton *)btn{
    [[SliderViewController sharedSliderController] closeSideBar];
}

- (void)toNewViewbtn:(UIButton *)btn{
    [[SliderViewController sharedSliderController] closeSideBarWithAnimate:YES complete:^(BOOL finished){
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"left";
    YYLetfItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];;
    NSArray *ar = [_arData objectAtIndex:indexPath.row];

    if (cell == nil){
        cell = [[YYLetfItemCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.delegate = self;
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    cell.indexPath = indexPath;
    cell.iconImage.image = [QHCommonUtil imageNamed:[ar objectAtIndex:1]];
    cell.itemL.text = [ar objectAtIndex:0];
    cell.itemL.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47;
}
-(void)cellDidSelected:(YYLetfItemCell *)cell
{
    NSArray *lineData = [_arData objectAtIndex:cell.indexPath.row];
    if ([[lineData objectAtIndex:0] isEqualToString:@"机票订单"]) {
        /*
         YYMyOrderListController *oederVC= [[YYMyOrderListController alloc]init];
         [[SliderViewController sharedSliderController] closeSideBarWithAnimate:YES complete:^(BOOL finished){
         
         [[SliderViewController sharedSliderController].navigationController pushViewController:oederVC animated:NO];
         
         
         }];
         */
    }
    
    [self backAction:nil];
    
}
#pragma mark - super

- (void)reloadImage{
    [super reloadImage];
    UIImageView *imageBgV = (UIImageView *)[self.view viewWithTag:18];
    UIImage *image = [QHCommonUtil imageNamed:@"sidebar_bg@2x.jpg"];
    [imageBgV setImage:image];
    
    UIImageView *imageBgV2 = (UIImageView *)[self.view viewWithTag:19];
    UIImage *image2 = [QHCommonUtil imageNamed:@"sidebar_bg_mask.png"];
    [imageBgV2 setImage:[image2 resizableImageWithCapInsets:UIEdgeInsetsMake(image2.size.height - 1, 0, 1, 0)]];

    UIImageView *headerIV = (UIImageView *)[self.view viewWithTag:20];
    UIImage *headerI = [QHCommonUtil imageNamed:@"chat_bottom_smile_nor.png"];
    [headerIV setImage:headerI];
    
    [_tableView reloadData];
}
- (void)reloadImage:(NSNotificationCenter *)notif{
    [self reloadImage];
}

#pragma - myMethods
- (void)personViewTapped:(id)sender
{
    
}
-(void)addPersonalInfo
{
    UIImage *personImage = [UIImage imageNamed:@"left_headImage"];
    UIButton *personView = [UIButton buttonWithType:0];
    personView.frame = CGRectMake(0, 73, personImage.size.width, personImage.size.height);
    [personView setImage:personImage forState:UIControlStateHighlighted];
    personView.backgroundColor = [UIColor clearColor];
    
    UIImage *logoImage = [UIImage imageNamed:@"left_UserIcon"];
    self.logoImageView = [[UIImageView alloc]initWithImage:logoImage];
    self.logoImageView.frame = CGRectMake(20* 320/SCREEN_SIZE.width, (personView.frame.size.height - 60)/2, logoImage.size.width, logoImage.size.height);
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = logoImage.size.width/2;
    self.logoImageView.layer.borderColor =  [UIColor whiteColor].CGColor;
    self.logoImageView.layer.borderWidth = 1.5f;
    
    
    [personView addSubview:self.logoImageView];
    nameL = [[UILabel alloc]init];
    nameL.frame = CGRectMake(100, 15, 120, 20);
    nameL.font = [UIFont fontWithName:FountName size:15.5];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"用户名";
    [personView addSubview:nameL];
    
    companyL = [[UILabel alloc] init];
    companyL.frame = CGRectMake(100, nameL.frame.origin.y + nameL.frame.size.height + 5, 220, 20);
    companyL.font = [UIFont fontWithName:FountName size:11];
    companyL.textAlignment = NSTextAlignmentLeft;
    companyL.textColor = [UIColor whiteColor];
    companyL.text = @"北京红橘科技有限公司";
    [personView addSubview:companyL];
    [_contentView addSubview:personView];

    UITapGestureRecognizer *personTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(personViewTapped:)];
    personTap.numberOfTapsRequired = 1;
    personTap.numberOfTouchesRequired = 1;
    [personView addGestureRecognizer:personTap];
}

-(void)addSettingBtn
{
    UIImage *setImage = [UIImage imageNamed:@"left_setImage"];
    UIButton *setBtn = [UIButton buttonWithType:0];
    [setBtn addTarget:self action:@selector(setTingPersonalInfo:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.frame = CGRectMake(15 * 320/SCREEN_SIZE.width, _contentView.bottom - setImage.size.height - 5, setImage.size.width, setImage.size.height);
    
    UIImage *iconImage = [UIImage imageNamed:@"left_seticon"];
    UIImageView *icon = [[UIImageView alloc]initWithImage:iconImage];
    icon.frame = CGRectMake(15, (setBtn.frame.size.height - iconImage.size.height)/2, iconImage.size.width, iconImage.size.height);
    [setBtn addSubview:icon];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 3, (setBtn.frame.size.height - 20)/2, 30, 20)];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"设置";
    titleL.font = [UIFont fontWithName:FountName size:11.5];
    [setBtn addSubview:titleL];
    [setBtn setImage:setImage forState:UIControlStateHighlighted];
    [_contentView addSubview:setBtn];
}
-(void)setTingPersonalInfo:(UIButton *)sender
{
    
}
#pragma mark - getter and setter

- (void)setCompanyName:(NSString *)companyName
{
    _companyName = companyName;
    companyL.text = _companyName;
}

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    if (!_logoImage) {
        _logoImage = [UIImage imageNamed:@"left_UserIcon"];
    }
    self.logoImageView.image = _logoImage;
}

- (void)setAttributesWithJSONObject:(NSDictionary *)dict
{
    self.name = [self noneNullAttribute:dict[@"name"]];
    self.companyName = [self noneNullAttribute:dict[@"companyName"]];
    self.username = [self noneNullAttribute:dict[@"username"]];
    self.idcardNO = [self noneNullAttribute:dict[@"identification"]];
    self.gender = [self noneNullAttribute:dict[@"gender"]];
    self.mobile = [self noneNullAttribute:dict[@"mobile"]];
    self.phone = [self noneNullAttribute:dict[@"phone"]];
    self.wxno = [self noneNullAttribute:dict[@"wxno"]];
    self.email = [self noneNullAttribute:dict[@"email"]];
}
- (id)noneNullAttribute:(id)attribute
{
    if (!([attribute isKindOfClass:[NSNull class]] ||
          !attribute ||
          ![attribute length])) {
        return attribute;
    }
    return nil;
}
#pragma mark - Network
- (void)getLogoFromServer
{
    
   
}

- (void)getCurrentUserInfo
{
    
}

@end
