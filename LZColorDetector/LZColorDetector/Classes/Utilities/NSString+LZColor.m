//
//  NSString+LZColor.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "NSString+LZColor.h"
#import "UIColor+LZColor.h"

@implementation NSString (LZColor)
- (UIColor *)colorFromHextString{
    
     unsigned int red;
     unsigned int blue;
     unsigned int green;
     unsigned int alpha;
    
    NSScanner *scaner = [NSScanner scannerWithString:[self substringWithRange:NSMakeRange(0, 2)]];
    
    [scaner scanHexInt:&red];
    
    scaner = [NSScanner scannerWithString:[self substringWithRange:NSMakeRange(2, 2)]];
    
    [scaner scanHexInt:&green];
    
    scaner = [NSScanner scannerWithString:[self substringWithRange:NSMakeRange(4, 2)]];
    
    [scaner scanHexInt:&blue];
    
    scaner = [NSScanner scannerWithString:[self substringWithRange:NSMakeRange(6, 2)]];
    
    [scaner scanHexInt:&alpha];

    
    return [UIColor lz_colorWithRed:red green:green  blue:blue  alpha:alpha];
}
@end
