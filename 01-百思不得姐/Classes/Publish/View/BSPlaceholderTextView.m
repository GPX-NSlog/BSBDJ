//
//  BSPlaceholderTextView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSPlaceholderTextView.h"
@interface BSPlaceholderTextView ()

@property (weak,nonatomic) UILabel *placeholderLabel;

@end


@implementation BSPlaceholderTextView

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 打开弹簧效果
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor lightGrayColor];
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 监听文字改变
- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
}

- (void)updatePlaceholderLabelSize {

    CGSize maxSize = CGSizeMake(BSScreenW - 2 * self.placeholderLabel.x, MAXFLOAT);
    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName : self.font}
                                                                context:nil].size;

}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabelSize];

}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self updatePlaceholderLabelSize];
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];

}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange];
}


@end
