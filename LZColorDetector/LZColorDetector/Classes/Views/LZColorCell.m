//
//  LZColorCell.m
//  LZColorDetector
//
//  Created by comst on 16/4/1.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZColorCell.h"
#import "UIColor+LZColor.h"

@interface LZColorCell ()

@property (weak, nonatomic) IBOutlet UIView *colorShowView;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;

@property (weak, nonatomic) IBOutlet UILabel *grennLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UILabel *hexLabel;

@end

@implementation LZColorCell

+ (instancetype)colorCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self config];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self config];
        
    }
    
    return  self;
}

- (void)config{
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackGround"]];
}

- (void)setCurrentColor:(UIColor *)currentColor{
    currentColor = currentColor;
    self.colorShowView.backgroundColor = currentColor;
    self.redLabel.text = [NSString stringWithFormat:@"%li", currentColor.redComponent];
    self.grennLabel.text = [NSString stringWithFormat:@"%li", currentColor.greenComponent];
    self.blueLabel.text = [NSString stringWithFormat:@"%li", currentColor.blueComponent];
    self.hexLabel.text = currentColor.hexString;
}
@end
