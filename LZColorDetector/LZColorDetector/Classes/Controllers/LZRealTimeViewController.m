//
//  LZRealTimeViewController.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZRealTimeViewController.h"
#import "GPUImage.h"
#import "UIColor+LZColor.h"
#import "LZColorStorage.h"
#import "UIView+LZFrame.h"
#import "SVProgressHUD.h"

@interface LZRealTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) GPUImageView *videoView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageRawDataOutput *rawDataOutPut;

@end

@implementation LZRealTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseConfig];
    [self configCameraView];
}

- (void)baseConfig{
    
}

- (void)configCameraView{
    
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    self.videoCamera = videoCamera;
    
//    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0, 0)];
    
    self.videoView = filteredVideoView;
    self.videoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view insertSubview:filteredVideoView atIndex:0];
    
    self.rawDataOutPut = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(480, 640) resultsInBGRAFormat:YES];
    
     __weak typeof(self) weakSelf = self;
    
    [self.rawDataOutPut setNewFrameAvailableBlock:^{
        
        CGPoint focusPoint = CGPointMake(240, 320);
        
        GPUByteColorVector colorVector = [weakSelf.rawDataOutPut colorAtLocation:focusPoint];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.selectedColor = [UIColor lz_colorWithRed:colorVector.red green:colorVector.green blue:colorVector.blue alpha:colorVector.alpha];
            
        });
    }];
    
    
    [self.videoCamera addTarget:self.videoView];
    [self.videoCamera addTarget:self.rawDataOutPut];
    // Add the view somewhere so it's visible
    
//    [videoCamera addTarget:customFilter];
//    [customFilter addTarget:filteredVideoView];
    
//    [videoCamera startCameraCapture];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.videoCamera startCameraCapture];
}

#pragma mark - layout subview
- (void)viewDidLayoutSubviews{
    self.videoView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.indicatorView.center = self.view.center;
}


#pragma mark - button Action
- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)saveAction:(UIButton *)sender {
    [[LZColorStorage sharedColorStorage] addColor:self.selectedColor];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}

#pragma mark - setter
- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    self.redLabel.text = [NSString stringWithFormat:@"%li", selectedColor.redComponent];
    self.greenLabel.text = [NSString stringWithFormat:@"%li", selectedColor.greenComponent];
    self.blueLabel.text = [NSString stringWithFormat:@"%li", selectedColor.blueComponent];
    self.indicatorView.backgroundColor = selectedColor;
}

#pragma mark - lazy load 

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        [self.view addSubview:_indicatorView];
        _indicatorView.bounds = CGRectMake(0, 0, 20, 20);
        _indicatorView.layer.cornerRadius =  10;
    }
    return _indicatorView;
}
@end
