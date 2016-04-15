//
//  UIView+BSExtension.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BSExtension)

@property (assign,nonatomic) CGSize size;

@property (assign,nonatomic) CGFloat width;
@property (assign,nonatomic) CGFloat height;

@property (assign,nonatomic) CGFloat x;
@property (assign,nonatomic) CGFloat y;

@property (assign,nonatomic) CGFloat centerX;
@property (assign,nonatomic) CGFloat centerY;

- (BOOL)isShowingOnKeyWindow;

+ (instancetype)viewFormXib;
@end
