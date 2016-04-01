//
//  UIColor+LZColor.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "UIColor+LZColor.h"
#import <objc/runtime.h>
@implementation UIColor (LZColor)

+ (UIColor*)lz_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha{
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
    
    color.redComponent = red;
    color.greenComponent  = green;
    color.blueComponent = blue;
    color.alphaValue = alpha;
    color.hexString = [NSString stringWithFormat:@"%02lX%02lX%02lX%02lX", (long)red, (long)green, (long)blue, (long)alpha];
    return color;
};

- (NSInteger)redComponent{
    NSNumber *red = objc_getAssociatedObject(self, @selector(redComponent));
    
    return [red integerValue];
}

- (void)setRedComponent:(NSInteger)redComponent{
    objc_setAssociatedObject(self, @selector(redComponent), @(redComponent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)greenComponent{
    NSNumber *green = objc_getAssociatedObject(self, @selector(greenComponent));
    
    return [green integerValue];
}

- (void)setGreenComponent:(NSInteger)greenComponent{
    objc_setAssociatedObject(self, @selector(greenComponent), @(greenComponent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)blueComponent{
    NSNumber *blue = objc_getAssociatedObject(self, @selector(blueComponent));
    
    return [blue integerValue];
}

- (void)setBlueComponent:(NSInteger)blueComponent{
    objc_setAssociatedObject(self, @selector(blueComponent), @(blueComponent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)alphaValue{
    NSNumber *alpha = objc_getAssociatedObject(self, @selector(alphaValue));
    return [alpha integerValue];
}

- (void)setAlphaValue:(NSInteger)alphaValue{
    objc_setAssociatedObject(self, @selector(alphaValue), @(alphaValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHexString:(NSString *)hexString{
    objc_setAssociatedObject(self, @selector(hexString), hexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hexString{
    
    return objc_getAssociatedObject(self, @selector(hexString));
}

@end
