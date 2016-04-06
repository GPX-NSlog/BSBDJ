//
//  BSWindow.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/1.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopWindow.h"


@implementation BSTopWindow

static UIWindow *window_;

+ (void)initialize {
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, BSScreenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
    window_.rootViewController = [[UIViewController alloc] init];
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];

}

+ (void)windowClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollerInWindow:window];

}

+ (void)searchScrollerInWindow:(UIView *)superview {
    for (UIScrollView *subview in superview.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        [self searchScrollerInWindow:subview];
    }

}
+ (void)show {

    window_.hidden = NO;
}


@end
