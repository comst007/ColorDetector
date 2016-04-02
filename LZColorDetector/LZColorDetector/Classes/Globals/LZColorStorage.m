//
//  LZColorStorage.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZColorStorage.h"
#import "SVProgressHUD.h"
#import "UIColor+LZColor.h"
static NSString *fileName = @"colorData.db";
static LZColorStorage *colorStorage_;

@interface LZColorStorage ()

@property (nonatomic, strong) NSMutableArray *colorsList;
@property (nonatomic, strong) FMDatabase *db;
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
    
    NSInteger red = newColor.redComponent;
    NSInteger green = newColor.greenComponent;
    NSInteger blue = newColor.blueComponent;
    NSInteger alpha = newColor.alphaValue;
    
    [self.db beginTransaction];
    if (![self.db executeUpdate:@"INSERT INTO COLORHISTORY(red, green, blue, alpha) VALUES(?, ?, ?, ?);", @(red), @(green), @(blue), @(alpha)]){
         [SVProgressHUD showErrorWithStatus:@"插入数据失败"];
        [self.db  rollback];
    }
    [self.db commit];
    
}

- (void)removeColor:(UIColor *)color{
    
    [self.colorsList removeObject:color];
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM COLORHISTORY WHERE red = %li AND green = %li AND blue = %li AND alpha = %li;", color.redComponent, color.greenComponent, color.blueComponent, color.alphaValue];
    
    [self.db beginTransaction];
    
    if (![self.db executeUpdate:deleteSQL]) {
       [SVProgressHUD showErrorWithStatus:@"删除数据失败"];
        [self.db rollback];
    }else{
        
        self.colorsList = nil;
    }
    
    [self.db commit];
    
}

- (void)removeColorAtIndex:(NSInteger)colorIndex{
    if (colorIndex >= 0 && colorIndex < self.colorsList.count ) {
        
        UIColor *color = [self.colorsList objectAtIndex:colorIndex];
        [self removeColor:color];
    }
}


- (NSMutableArray *)colorsList{
    if (!_colorsList) {
        _colorsList = [[NSMutableArray alloc] init];
        NSString *selectSQL = @"SELECT * FROM COLORHISTORY;";
        
        FMResultSet *res = [self.db executeQuery:selectSQL];
        NSInteger red;
        NSInteger green;
        NSInteger blue;
        NSInteger alpah;
        while ([res next]) {
            
            red = [res intForColumn:@"red"];
            green = [res intForColumn:@"green"];
            blue = [res intForColumn:@"blue"];
            alpah = [res intForColumn:@"alpha"];
            
            UIColor *colorItem = [UIColor lz_colorWithRed:red green:green blue:blue alpha:alpah];
            [_colorsList addObject:colorItem];
        }
    }
    return _colorsList;
}

- (FMDatabase *)db{
    if (!_db) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self databaseFilePath]]) {
            _db = [[FMDatabase alloc] initWithPath:[self databaseFilePath]];
            if (![_db open]) {
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                return nil;
            }
            NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS COLORHISTORY (id integer primary key autoincrement, red integer, green integer, blue integer, alpha integer);";
            if (![_db executeUpdate:createTableSQL]) {
                [SVProgressHUD showErrorWithStatus:@"数据初始化失败"];
                return nil;
            }
            
            NSString *insertSQL = @"INSERT INTO COLORHISTORY(red, green, blue, alpha) VALUES(123, 66, 255, 255);";
            
            if (![_db executeUpdate:insertSQL]) {
                [SVProgressHUD showErrorWithStatus:@"数据插入失败"];
                return nil;
            }

            
        }else{
            _db = [[FMDatabase alloc] initWithPath:[self databaseFilePath]];
            if (![_db open]) {
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                return nil;
            }
        }
    }
    return _db;
}

- (NSString *)databaseFilePath{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [path stringByAppendingPathComponent:fileName];
}

- (void)dealloc{
    [self.db close];
    self.db = nil;
    
}

@end
