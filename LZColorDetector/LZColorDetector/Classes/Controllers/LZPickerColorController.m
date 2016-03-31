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

@interface LZPickerColorController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

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


#pragma mark - imageview tap gesture action

- (void)tapAction:(UIGestureRecognizer *)tapGesture{
    
    CGPoint postion = [tapGesture locationInView:self.imageView];
    NSLog(@"touch : %@", NSStringFromCGPoint(postion));
    NSString *hexString = [self.imageView hexColorStringInPosition:postion];
    UIColor *color = [hexString colorFromHextString];
    
    self.bottomContainerView.backgroundColor = color;
    
    NSLog(@"rgb: %li, %li, %li", color.redComponent, color.greenComponent, color.blueComponent);
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
    
}


#pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.scaleSlider.value = scrollView.zoomScale;
}

#pragma mark - touch 


@end
