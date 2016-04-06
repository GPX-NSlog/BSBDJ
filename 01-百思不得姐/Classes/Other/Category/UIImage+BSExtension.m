//
//  UIImage+BSExtension.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/3.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "UIImage+BSExtension.h"

@implementation UIImage (BSExtension)

- (UIImage *)circleImage {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 取得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个原
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return image;
}

@end
