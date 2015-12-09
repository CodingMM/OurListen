//
//  ScannerViewController.m
//  ScannerDemo
//
//  Created by Elean on 15/12/7.
//  Copyright (c) 2015年 Elean. All rights reserved.
//

#import "ScannerViewController.h"
#import "ScannerDetailController.h"
#import "ELNAlertView.h"
#import "NSString+category.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface ScannerViewController ()<ELNAlertViewDelegate>
@property (nonatomic,strong)UIButton *lightBtn;
//闪光灯

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self prepareScanView];
    
    [self setUpCamera];
    
    
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //Start
    [self.session startRunning];
    
}
- (void)viewDidDisappear:(BOOL)animated{

    //Stop
    [self.session stopRunning];

    [super viewDidDisappear:animated];
}


#pragma mark -- 设置摄像头

- (void)setUpCamera{
    
// Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [self.device lockForConfiguration:nil];
    
    if ([self.device hasTorch]) {
        
        if ([self.device isTorchModeSupported:AVCaptureTorchModeAuto]) {
            
            self.device.torchMode  = AVCaptureTorchModeAuto;
            
        }
        else{
            
            self.device.torchMode  = AVCaptureTorchModeOff;
        }
        
    }
    
    [self.device unlockForConfiguration];
    
    
    
//Session
    _session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    
    
// Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    if ([self.session canAddInput:self.input])
    {
        
        [self.session addInput:self.input];
        
    }
    
    
// Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    if ([self.session canAddOutput:self.output]){
        
        [self.session addOutput:self.output];
        
    }
    
    
//视频输出
    _videoOutput  = [[AVCaptureVideoDataOutput alloc]init] ;
    
    if ([self.session canAddOutput:_videoOutput]){
        
        [self.session addOutput:_videoOutput];
        
    }
    
    
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    @try {
        
        // 条码类型 AVMetadataObjectTypeQRCode
        self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    }
    @catch (NSException *exception) {
        
        
        NSArray * titlesArr = @[@"取消"];
        
        ELNAlertView * alertView = [[ELNAlertView alloc]initWithTitle:@"提示" message:@"请在设备的 设置-隐私-相机 中允许访问相机。" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:titlesArr];
     
        [self.view addSubview:alertView];
        
    }
   
    
//Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame = CGRectMake(0,0,SCREEN_W,SCREEN_H);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    


}


#pragma mark -- 设置视图
- (void)prepareScanView {
//背景
    UIImageView *readerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan5_bg.png"]];
    
    readerBg.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H) ;
   
    readerBg.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:readerBg];
    
//标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W - 60)*0.5, 30, 60, 30)];
    
    lblTitle.textAlignment =NSTextAlignmentCenter;
    
    lblTitle.text = @"扫 描";
    
    lblTitle.font = [UIFont systemFontOfSize:25.0f];
    
    lblTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:lblTitle];
    
//返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 70, 35)];
   
   [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_white.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(scanCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
//开启相机闪光灯按钮
    _lightBtn = [[UIButton alloc]initWithFrame: CGRectMake(SCREEN_W - 50, 25, 35, 35)];
    
    _lightBtn.backgroundColor = [UIColor clearColor];
    
    _lightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_01.png"] forState:UIControlStateNormal];
    
    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_02.png"] forState:UIControlStateSelected];
    
    [_lightBtn addTarget:self action:@selector(openCameraFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    
//如果设置手电筒自动开启，按钮初始状态需要改变
    if ([self.device hasTorch]) {
        if (self.device.torchMode == AVCaptureTorchModeAuto){
            
            //如果手电筒亮度为0，表示关闭
            if (self.device.torchLevel==0) {
                
                [_lightBtn setSelected:NO];
                
            }
            else{
                
                [_lightBtn setSelected:YES];
            }
            
        }
    }
    
    [self.view addSubview:_lightBtn];
    
    
//扫描线
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 155, SCREEN_W, 29)];
    
    scanLine.image = [UIImage imageNamed:@"scan_line"];
    
    scanLine.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:scanLine];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.duration=2.f;
    theAnimation.repeatCount=FLT_MAX;
    theAnimation.autoreverses=NO;
    theAnimation.removedOnCompletion=NO;
    
   
        CGRect rect = scanLine.frame;
        rect.origin.y += 35;
        scanLine.frame = rect;
        
        theAnimation.toValue=[NSNumber numberWithFloat:190];
    
    
    [scanLine.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

#pragma mark -- AlertView delegate

- (void)selectedIndex:(NSInteger)index{
    
    if (index == 0) {
        
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
   
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    for(AVMetadataObject *current in metadataObjects) {
        
        if ([current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                
                if ([scannedValue trim].length != 0) {
                    
                    //播放扫描声音
                    [self playScanSound];
                    [self.session stopRunning];
                    
                 
                    ScannerDetailController * detailView = [[ScannerDetailController alloc]init];
                    
                    detailView.scannerValueStr = scannedValue;
                    
                    [self.navigationController pushViewController:detailView animated:YES];
                    
                   
                }
            }
        }
    }
    
}

#pragma mark -- 播放声音
- (void)playScanSound{
    
    //系统音频ID，用来注册我们将要播放的声音
    SystemSoundID scanSoundID;
    //音乐文件路径
    CFURLRef thesoundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"]];
    //变量SoundID与URL对应
    AudioServicesCreateSystemSoundID(thesoundURL, &scanSoundID);
    //播放SoundID声音
    AudioServicesPlaySystemSound(scanSoundID);
}

#pragma mark -- 取消扫描
- (void)scanCancel{
    
    [self.session stopRunning];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -- 开启/关闭 手电筒
- (void)openCameraFlashlight:(id)sender{
    
    
    if (![self.device hasTorch]) {
        return;
    }
    
    if (self.device.torchMode == AVCaptureTorchModeOff) {
        
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOn;//开启
        [self.device unlockForConfiguration];
        [_lightBtn setSelected:YES];
        
    }
    else if (self.device.torchMode == AVCaptureTorchModeOn) {
        
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOff;//关闭
        [self.device unlockForConfiguration];
        [_lightBtn setSelected:NO];
        
    }
    else if (self.device.torchMode == AVCaptureTorchModeAuto){
        
        //如果手电筒亮度为0，表示关闭
        if (self.device.torchLevel==0) {
            
            [self.device lockForConfiguration:nil];
            self.device.torchMode = AVCaptureTorchModeOn;//开启
            [self.device unlockForConfiguration];
            [_lightBtn setSelected:YES];
        }
        else{
            
            [self.device lockForConfiguration:nil];
            self.device.torchMode = AVCaptureTorchModeOff;//关闭
            [self.device unlockForConfiguration];
            [_lightBtn setSelected:NO];
        }
        
    }
    
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
