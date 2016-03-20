//
//  UIBarButtonItem+BSExtension.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BSExtension)

+ (instancetype)itemWithImg:(NSString*) imgName highlight:(NSString*) highlight target:(id) target action:(SEL) action;

@end
