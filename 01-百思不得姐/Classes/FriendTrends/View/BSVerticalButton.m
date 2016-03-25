//
//  BSVerticalButton.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/23.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSVerticalButton.h"

@implementation BSVerticalButton

- (void)awakeFromNib {

    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return  self;
}

- (void)setup {

    // 设置文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片frame
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 设置label
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.imageView.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
}

@end
