//
//  BSTagButton.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/6.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTagButton.h"

@implementation BSTagButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BSTagBtnColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = BSTagFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * BSTagBtnMargin;
    self.height = BSTagH;
}
- (void)layoutSubviews {
    [super layoutSubviews];
  
    self.titleLabel.x = BSTagBtnMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + BSTagBtnMargin;
    

}

@end
