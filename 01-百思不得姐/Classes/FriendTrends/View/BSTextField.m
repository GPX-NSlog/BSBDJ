//
//  BSTextField.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/23.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTextField.h"

static NSString *const BSPlaceholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation BSTextField

- (void)awakeFromNib {

    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    
    [self setValue:self.textColor forKeyPath:BSPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
    
}

- (BOOL)resignFirstResponder {
    [self setValue:[UIColor grayColor] forKeyPath:BSPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}
@end
