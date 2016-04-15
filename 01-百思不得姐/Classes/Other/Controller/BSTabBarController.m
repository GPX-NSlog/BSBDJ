//
//  BSTabBarController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/19.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTabBarController.h"
#import "BSEssenceViewController.h"
#import "BSNewViewController.h"
#import "BSFriendTrendsViewController.h"
#import "BSMeViewController.h"
#import "BSTabBar.h"
#import "BSNavigationController.h"

@interface BSTabBarController ()

@end

@implementation BSTabBarController

+ (void)initialize {
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 凡是后面带有UI_APPEARANCE_SELECTOR的方法,都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置所有item的属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    // 添加子控制器
    [self setup:[[BSEssenceViewController alloc] init] title:@"精华" img:@"tabBar_essence_icon" seleImg:@"tabBar_essence_click_icon"];
    
    [self setup:[[BSNewViewController alloc] init] title:@"新帖" img:@"tabBar_new_icon" seleImg:@"tabBar_new_click_icon"];
    
    [self setup:[[BSFriendTrendsViewController alloc] init] title:@"关注" img:@"tabBar_friendTrends_icon" seleImg:@"tabBar_friendTrends_click_icon"];
    
    [self setup:[[BSMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" img:@"tabBar_me_icon" seleImg:@"tabBar_me_click_icon"];
    
    [self setValue:[[BSTabBar alloc] init] forKey:@"tabBar"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];

}
- (void)setup:(UIViewController *)vc title:(NSString *)title img:(NSString*)img seleImg:(NSString *)seleImg {
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:img];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seleImg];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
