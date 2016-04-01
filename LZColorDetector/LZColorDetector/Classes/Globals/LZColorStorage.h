//
//  LZColorStorage.h
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LZColorStorage : NSObject

+ (instancetype)sharedColorStorage;

- (NSArray *)allColors;

- (void)removeColor:(UIColor *)color;

- (void)removeColorAtIndex:(NSInteger)colorIndex;

- (void)addColor:(UIColor *)newColor;

@end
