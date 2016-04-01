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

#define indicatorViewW 16

@interface LZPickerColorController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) LZColorCell *colorCellView;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation LZPickerColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configScrollView];
    [self configImageView];
}

- (void)viewDidLayoutSubviews{
    self.imageView.width = self.containerScrollView.width - 2 * 20;
    self.imageView.height = self.imageView.width * self.selectedImage.size.height / self.selectedImage.size.width;
    [self updateScrollViewContentSize];
    
    CGFloat colorCellViewPading = 10 ;
    self.colorCellView.x = colorCellViewPading;
    self.colorCellView.y = colorCellViewPading;
    self.colorCellView.height = self.bottomContainerView.height - 2 * colorCellViewPading;
    self.colorCellView.width = self.bottomContainerView.width - 2 * colorCellViewPading;
    
}



- (void)configNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
}

- (void)configScrollView{
    self.containerScrollView.contentSize = CGSizeMake(1000, 1000);
    self.containerScrollView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.containerScrollView.delegate =  self;
    self.containerScrollView.minimumZoomScale = 1;
    self.containerScrollView.maximumZoomScale = 10;
    self.containerScrollView.bounces = NO;
    self.containerScrollView.bouncesZoom = NO;
    
}

- (void)updateScrollViewContentSize{
    self.containerScrollView.contentSize = CGSizeMake(self.imageView.width,self.imageView.height);
}

- (void)configImageView{
    if (self.selectedImage == nil) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, 100, 100);
    imageView.image = self.selectedImage;
    [self.containerScrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    [imageView addGestureRecognizer:tapGesture];
    
}




#pragma mark - slider change
- (IBAction)scaleValueChanged:(UISlider *)sender {
    
    self.containerScrollView.zoomScale = self.scaleSlider.value;
}

#pragma mark - navItem Action

- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveAction{
    
    [[LZColorStorage sharedColorStorage] addColor:self.selectedColor];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    
}


#pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.scaleSlider.value = scrollView.zoomScale;
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
        _indicatorView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
        [self.containerScrollView addSubview:_indicatorView];
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
    
    
    [self configColorInfoInPosition:position];
    
}

#pragma mark - indicatorView pan action

- (void)panAction:(UIPanGestureRecognizer *)gesture{
    
    
    CGPoint position = [gesture locationInView:self.imageView];
    CGPoint realPosition ;
    CGFloat cornerRadius = 0;
    realPosition.x = MIN(CGRectGetMaxX(self.imageView.frame) - cornerRadius,  MAX(CGRectGetMinX(self.imageView.frame) + cornerRadius, position.x));
    realPosition.y = MIN(CGRectGetMaxY(self.imageView.frame) - cornerRadius, MAX(CGRectGetMinY(self.imageView.frame) + cornerRadius, position.y));
    
    [self configColorInfoInPosition:realPosition];
    
    
}

- (void)configColorInfoInPosition:(CGPoint)position{
    self.indicatorView.center = position;
    self.indicatorView.hidden = NO;
    NSString *hexString = [self.imageView hexColorStringInPosition:position];
    UIColor *color = [hexString colorFromHextString];
    
    self.colorCellView.currentColor = color;
    
    self.selectedColor = color;
}

@end
