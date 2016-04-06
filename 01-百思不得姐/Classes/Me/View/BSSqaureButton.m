//
//  BSSqaureButton.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/4.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSSqaureButton.h"
#import "BSSquaresModel.h"
#import "UIButton+WebCache.h"

@implementation BSSqaureButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}
- (void)setup {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.15;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
}


- (void)setSquare:(BSSquaresModel *)square {
    _square = square;
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}


@end
