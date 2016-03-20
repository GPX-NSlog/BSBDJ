//
//  BSTabBar.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTabBar.h"

@interface BSTabBar ()

@property (weak,nonatomic) UIButton *publishBtn;

@end

@implementation BSTabBar
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        // 添加发布按钮
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        publishBtn.size = publishBtn.currentBackgroundImage.size;
        self.publishBtn = publishBtn;
        [self addSubview:publishBtn];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
//    self.publishBtn.bounds = CGRectMake(0, 0, self.publishBtn.currentBackgroundImage.size.width,self.publishBtn.currentBackgroundImage.size.height);

    self.publishBtn.center = CGPointMake(width*0.5, height*0.5);
    
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    int  i = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        CGFloat buttonX = buttonW * (i>1?(i+1):(i));
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        i++;
    }     
}
@end
