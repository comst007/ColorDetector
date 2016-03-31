//
//  UIColor+LZColor.h
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LZColor)
@property (nonatomic, assign) NSInteger redComponent;
@property (nonatomic, assign) NSInteger greenComponent;
@property (nonatomic, assign) NSInteger blueComponent;
+ (UIColor *)lz_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;
@end
