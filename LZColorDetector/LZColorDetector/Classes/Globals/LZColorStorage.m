//
//  LZColorStorage.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZColorStorage.h"

static LZColorStorage *colorStorage_;

@interface LZColorStorage ()

@property (nonatomic, strong) NSMutableArray *colorsList;

@end
@implementation LZColorStorage

+(instancetype)sharedColorStorage{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (colorStorage_ == nil) {
            colorStorage_ = [[LZColorStorage alloc] init];
        }
    });
    return colorStorage_;
}

- (NSArray *)allColors{
    
    return self.colorsList;
}

- (void)addColor:(UIColor *)newColor{
    
    [self.colorsList addObject:newColor];
}

- (void)removeColor:(UIColor *)color{
    
    [self.colorsList removeObject:color];
}

- (void)removeColorAtIndex:(NSInteger)colorIndex{
    if (colorIndex >= 0 && colorIndex < self.colorsList.count ) {
        
        [self.colorsList removeObjectAtIndex:colorIndex];
    }
}


- (NSMutableArray *)colorsList{
    if (!_colorsList) {
        _colorsList = [[NSMutableArray alloc] init];
    }
    return _colorsList;
}

@end
