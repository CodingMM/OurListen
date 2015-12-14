//
//  CCAlertView.m
//  ListenProject
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 夏婷. All rights reserved.
//

#import "CCAlertView.h"

#define ITEM_W (_line.frame.size.width)/(ITEM_COUNT * 1.0)
#define ITEM_H 44
#define TINT_COLOR [UIColor colorWithRed:14/255.f green:83/255.f blue:235/255.f alpha:1]
#define CENTER_H  (self.frame.size.width-100)*0.7)

@implementation CCAlertView{
    
    UIView * _centerView;
    
    NSString * _title;
    //title
    
    NSString * _message;
    //message
    
    NSString * _cancelTile;
    //取消按钮
    
    NSArray * _titles;
    //其他按钮
    
    UILabel * _line;
    //分割线
    
    UIButton * _lastSelectedBtn;
    
    
    NSMutableArray * _buttons;
    
    
    id<CCAlertViewDelegate>  _delegate;
    
    
}

- (instancetype )initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CCAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)buttonTitles{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        
        self.userInteractionEnabled = YES;
        
        _title = title;
        
        _message = message;
        
        _cancelTile = cancelButtonTitle;
        
        _delegate = delegate;
        
        _titles = [NSMutableArray arrayWithArray:buttonTitles];
        
        _buttons = [NSMutableArray array];
        
        [self createCenterView];
        
        [self createTitle];
        
        [self createMessage];
        
        [self createSeg];
        
        
        
        
        
    }
    return self;
    
}
#pragma mark -- 设置中心区域
- (void)createCenterView{
    
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(50, 0 , self.frame.size.width - 100,CENTER_H];
    _centerView.center = self.center;
                                                          
    _centerView.backgroundColor = [UIColor whiteColor];
                                                          
    _centerView.layer.borderColor = TINT_COLOR.CGColor;
                                                        
    _centerView.layer.borderWidth = 0.8;
                                                          
    _centerView.layer.cornerRadius = 10;
                                                          
                                                          
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:_centerView.bounds];
                                                          
    imageView.image = [UIImage imageNamed:@"alertCenter.png"];
                                                          
                                                          
   [_centerView addSubview:imageView];
                                                          
   _line = [[UILabel alloc]initWithFrame:CGRectMake(10, _centerView.frame.size.height - ITEM_H, _centerView.frame.size.width - 20, 0.5)];
                                                          
   _line.backgroundColor = TINT_COLOR;
                                                          
  [_centerView addSubview:_line];
                                                          
  [self addSubview:_centerView];
                                                          
                                                          
                                                          
}
                                                          
                                                          
                                                          
#pragma mark -- 设置title
                                                          
- (void)createTitle{

    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, _centerView.frame.size.width - 20, 30)];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
                                                              
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
                                                              
    titleLabel.textColor = TINT_COLOR;
                                                              
    titleLabel.text = _title;
                                                              
    [_centerView addSubview:titleLabel];
                                                              
                                                              
}
                                                          
#pragma mark -- 设置message
- (void)createMessage{
                                                              
   UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, _centerView.frame.size.width - 20, _line.frame.origin.y - 55)];
                                                              
   messageLabel.text = _message;
                                                              
   messageLabel.numberOfLines = 0;
                                                              
   messageLabel.textAlignment = NSTextAlignmentCenter;
                                                              
   messageLabel.textColor = TINT_COLOR;
                                                              
  [_centerView addSubview:messageLabel];
                                                              
}
                                                          
#pragma mark -- 设置按钮

- (void)createSeg{
                                                              
  NSMutableArray * titles = [NSMutableArray array];
  
    if(_cancelTile){
    
     [titles addObject:_cancelTile];
     
    }
                                                              
  [titles addObjectsFromArray:_titles];

    if (titles.count) {
                                                                  
    [_buttons removeAllObjects];
                                                                  
                                                                  
    if (titles.count == 1 || (titles.count != 2 && titles.count <= 5)) {
                                                                      
        for (int i = 0; i < titles.count; i++) {
                                                                          
                                                                          
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, _line.frame.origin.y + 1 +i*ITEM_H, _line.frame.size.width, ITEM_H)];
                                                                          
        btn.tag = 1000+i;
                                                                          
        [btn setTitleColor:TINT_COLOR forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
                                                                          
                                                                          
        [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                                                                          
                                                                          
        [_buttons addObject:btn];
                                                                          
        [_centerView addSubview:btn];
                                                                          
    if (titles.count != 0 && i < titles.count - 1) {
                                                                              
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, ITEM_H-0.5 , btn.frame.size.width,0.5)];
                                                                              
        label.backgroundColor = TINT_COLOR;
                                                                              
        [btn addSubview:label];
        
        }
                                                                          
      }
                                                                      
    if (titles.count > 1) {
                                                                          
        CGRect rect = _centerView.frame;
        
        rect.size.height += ITEM_H * (titles.count - 1);
        
        _centerView.frame = rect;
        
        _centerView.center = self.center;
                                                                          
        }
    }
        
   else {
                                                                      
    for (int i = 0; i < titles.count; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((_centerView.frame.size.width - 20)/2.0*i+10, _line.frame.origin.y + 1,(_centerView.frame.size.width - 20)*0.5, ITEM_H)];
                                                                          
        btn.tag = 1000+i;
                                                                          
        btn.backgroundColor = [UIColor whiteColor];
                                                                          
                                                                          
        [btn setTitleColor:TINT_COLOR forState:UIControlStateNormal];
                                                                          
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                                                                          
        [btn setTitle:titles[i] forState:UIControlStateNormal];
                                                                          
        [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                                                                          
        if(i == 0){
                                                                              
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.size.width- 0.5, 0, 0.5, ITEM_H-2)];
                                                                              
        label.backgroundColor = TINT_COLOR;
                                                                              
        [btn addSubview:label];
                                                                              
        }
                                                                          
      [_buttons addObject:btn];
                                                                          
                                                                          
      [_centerView addSubview:btn];
                                                                          
        }
     }
                                                                  
                                                                  
                                                                  
  }
    
    UIButton * btn = (UIButton *)[_buttons firstObject];
    
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                                                              
}
                                                          
#pragma mark -- 点击按钮触发的事件
                                                          
- (void)touchUpInside:(id)sender{
                                                              
                                                              
  UIButton * selectedBtn = (UIButton *)sender;
                                                              
  for (NSInteger i = 0; i < _buttons.count; i++) {
                                                                  
    UIButton * btn = (UIButton *)_buttons[i];
                                                                  
     if (selectedBtn == btn) {
        
         //获取到对应的index
                                                                      
        btn.selected = YES;
        
        btn.backgroundColor = TINT_COLOR;
        
       if(_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]){
                                                                          
        [_delegate selectedIndex:i];
        
        [self removeFromSuperview];
    }
                                                                      
  }
 }
}
                                                          
                                                          
- (void)dealloc{
                                                              
    _delegate = nil;
                                                              
}
                                                          
                                                          
                                                          


@end
