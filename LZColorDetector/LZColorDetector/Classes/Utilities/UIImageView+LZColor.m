//
//  UIImageView+LZColor.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "UIImageView+LZColor.h"
#import "UIView+LZFrame.h"

@implementation UIImageView (LZColor)

- (NSString *)hexColorStringInPosition:(CGPoint)position{
    
    CGFloat offsetX = ceil(position.x);
    CGFloat offsetY = ceil(position.y);
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char dataString[4];
    CGContextRef bitmapCtx = CGBitmapContextCreate(dataString, 1, 1, 8, 4, rgbSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(bitmapCtx, - offsetX, - offsetY);
    
    [self.layer renderInContext:bitmapCtx];
    
    NSString *hexString = [NSString stringWithFormat:@"%02x%02x%02x%02x", dataString[0], dataString[1], dataString[2], dataString[3]];
    NSLog(@"hex: %@", hexString);
    CGColorSpaceRelease(rgbSpace);
    CGContextRelease(bitmapCtx);
    
    return hexString;
}
@end
