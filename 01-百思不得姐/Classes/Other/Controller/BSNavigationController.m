//
//  BSNavigationController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSNavigationController.h"

@implementation BSNavigationController

// 当第一次使用这个类的时候回调用一次
+ (void)initialize {
    // 设置导航栏文字属性
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];

    // 设置item文字属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemEnable = [NSMutableDictionary dictionary];
    itemEnable[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    itemEnable[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:itemEnable forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    self.interactivePopGestureRecognizer.delegate = nil;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button sizeToFit];
        // 按钮内部所有美容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 缩小距离
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
   
}


- (void)back {
    [self popViewControllerAnimated:YES];
}
@end
