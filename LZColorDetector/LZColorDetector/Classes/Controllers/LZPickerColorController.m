//
//  LZPickerColorController.m
//  LZColorDetector
//
//  Created by comst on 16/3/31.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZPickerColorController.h"
#import "UIView+LZFrame.h"
#import "UIImageView+LZColor.h"
#import "NSString+LZColor.h"
#import "UIColor+LZColor.h"
#import "LZColorStorage.h"
#import "SVProgressHUD.h"
#import "LZColorCell.h"

#define indicatorViewW 20

@interface LZPickerColorController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (nonatomic, strong) UIImageView *scrollViewShaddowView;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) LZColorCell *colorCellView;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation LZPickerColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Color Detector";
    
    [self configNav];
    [self configSlider];
    [self configScrollView];
    [self configImageView];
}

- (void)viewDidLayoutSubviews{
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.containerScrollView.width * self.containerScrollView.zoomScale;
    self.imageView.height = self.containerScrollView.height * self.containerScrollView.zoomScale;
   
   
//    [self updateScrollViewContentSize];
   
    CGFloat colorCellViewPading = 0 ;
    self.colorCellView.x = colorCellViewPading;
    self.colorCellView.y = colorCellViewPading;
    self.colorCellView.height = self.bottomContainerView.height - 2 * colorCellViewPading;
    self.colorCellView.width = self.bottomContainerView.width - 2 * colorCellViewPading;
    
    self.scrollViewShaddowView.frame = CGRectMake(0, 0, self.containerScrollView.width, self.containerScrollView.height);
    
}


- (void)configSlider{
    [self.scaleSlider setThumbImage:[UIImage imageNamed:@"SliderThumnail"] forState:UIControlStateNormal];
}

- (void)configNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)configScrollView{
    self.containerScrollView.contentSize = CGSizeMake(10000, 10000);
//    self.containerScrollView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.containerScrollView.clipsToBounds = YES;
    self.containerScrollView.delegate =  self;
    self.containerScrollView.minimumZoomScale = 1;
    self.containerScrollView.maximumZoomScale = 10;
    self.containerScrollView.bounces = NO;
    self.containerScrollView.bouncesZoom = NO;
    self.containerScrollView.backgroundColor = [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:54 / 255.0 alpha:1];
    
    self.scrollViewShaddowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scollViewInnerShadow"]];
    [self.containerScrollView insertSubview:self.scrollViewShaddowView atIndex:0];
    
}

//- (void)updateScrollViewContentSize{
//    self.containerScrollView.contentSize = CGSizeMake(self.imageView.width,self.imageView.height);
//}

- (void)configImageView{
    if (self.selectedImage == nil) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    
    
    [self.containerScrollView addSubview:imageView];
    self.imageView = imageView;
    self.imageView.image = self.selectedImage;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    [imageView addGestureRecognizer:tapGesture];
    
    [self viewDidLayoutSubviews];
    
}




#pragma mark - slider change
- (IBAction)scaleValueChanged:(UISlider *)sender {
    self.indicatorView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.containerScrollView setZoomScale:sender.value];
    
//    NSLog(@"%@", NSStringFromCGRect(self.imageView.frame));
}

#pragma mark - navItem Action

- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveAction{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [[LZColorStorage sharedColorStorage] addColor:self.selectedColor];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.view.userInteractionEnabled = YES;
    });
    
    
}


#pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.indicatorView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.scaleSlider.value = scrollView.zoomScale;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.indicatorView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - tlazyload

- (LZColorCell *)colorCellView{
    if (!_colorCellView) {
        _colorCellView = [LZColorCell colorCell];
        _colorCellView.backgroundColor = [UIColor clearColor];
        [self.bottomContainerView addSubview:_colorCellView];
    }
    return _colorCellView;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicatorViewW, indicatorViewW)];
        _indicatorView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ColorIndicator"]];
        [_indicatorView addSubview:imageView];
        [self.view addSubview:_indicatorView];
        
        _indicatorView.hidden = YES;
        _indicatorView.layer.cornerRadius = indicatorViewW / 2;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        
        [_indicatorView addGestureRecognizer:panGesture];
        
        
    }
    return _indicatorView;
}


#pragma mark - imageview tap gesture action

- (void)tapAction:(UIGestureRecognizer *)tapGesture{
    
    CGPoint position = [tapGesture locationInView:self.imageView];
//    NSLog(@"%@, %@, %@, %@", NSStringFromCGRect(self.imageView.frame), @(self.scaleSlider.value), @(self.containerScrollView.zoomScale), NSStringFromCGPoint(self.containerScrollView.contentOffset));
    
    [self configColorInfoInPosition:position];
    
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
   
    
}

#pragma mark - indicatorView pan action

- (void)panAction:(UIPanGestureRecognizer *)gesture{
    
    
    CGPoint position = [gesture locationInView:self.imageView];
    CGPoint realPosition ;
    CGFloat cornerRadius = 0;
    realPosition.x = MIN(self.imageView.width - cornerRadius,  MAX(cornerRadius, position.x));
    realPosition.y = MIN(self.imageView.height - cornerRadius, MAX(cornerRadius, position.y));
    
    [self configColorInfoInPosition:realPosition];
    
    
}

- (void)configColorInfoInPosition:(CGPoint)position{
    
    self.indicatorView.center = [self.imageView convertPoint:position toView:self.view];
    self.indicatorView.hidden = NO;
    
    NSString *hexString = [self.imageView hexColorStringInPosition:position];
    UIColor *color = [hexString colorFromHextString];
    
    self.colorCellView.currentColor = color;
    
    self.selectedColor = color;
}

@end
