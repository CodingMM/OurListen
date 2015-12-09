//
//  ScannerViewController.h
//  ScannerDemo
//
//  Created by Elean on 15/12/7.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//音频的播放或者录制
#import <AudioToolbox/AudioToolbox.h>
//音频的播放或者录制 （振动）

@interface ScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
//捕获二维码回调的协议
@property (strong,nonatomic)AVCaptureDevice *device;
//获取相机的相关属性
@property (strong,nonatomic)AVCaptureDeviceInput *input;
//输入
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
//输入
@property (strong,nonatomic)AVCaptureSession *session;
//音频、视频采集
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
//摄像头捕获的原始数据
@property (strong,nonatomic)AVCaptureVideoDataOutput *videoOutput;
//视频输出，为了手电筒自动亮
@end
