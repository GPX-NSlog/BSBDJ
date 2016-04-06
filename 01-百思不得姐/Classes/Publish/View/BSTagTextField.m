//
//  BSTagTextField.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/6.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTagTextField.h"

@implementation BSTagTextField


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.height = BSTagH;
        self.font = [UIFont systemFontOfSize:14];
        self.placeholder = @"多个标签用逗号或者换行隔开";
    }
    return self;
}

- (void)deleteBackward {
    
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
}

@end
