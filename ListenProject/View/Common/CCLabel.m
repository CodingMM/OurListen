//
//  ELNLabel.m
//  ScannerDemo
//
//  Created by Elean on 15/12/8.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import "CCLabel.h"

@implementation CCLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _color = [UIColor blueColor];
              
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
   NSMutableAttributedString *  attriString = [self getAttributedString];
    
    //在代码中我们调整了CTM(current transformation matrix)，这是因为Quartz 2D的坐标系统不同
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    
    //CTFramesetter是CTFrame的创建工厂，NSAttributedString需要通过CTFrame绘制到界面上，得到CTFramesetter后，创建path（绘制路径），然后得到CTFrame，最后通过CTFrameDraw方法绘制到界面上。
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
    
    
}

-(NSMutableAttributedString *)getAttributedString{
    
    //创建一个NSMutableAttributedString
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString:self.textStr];
    
    //添加下划线
    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                        range:NSMakeRange(0, self.textStr.length)];
    //设置字体颜色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)_color.CGColor
                        range:NSMakeRange(0, self.textStr.length)];
    
    //设置字体大小
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:20.0] range:NSMakeRange(0, self.textStr.length)];
    return attriString;
}



@end
