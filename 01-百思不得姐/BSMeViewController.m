//
//  BSMeViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSMeViewController.h"

@interface BSMeViewController ()

@end

@implementation BSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImg:@"mine-setting-icon" highlight:@"mine-setting-icon-click" target:self action:@selector(didClicksettingBtn)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImg:@"mine-moon-icon" highlight:@"mine-moon-icon-click" target:self action:@selector(didClickmoonBtn)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
}

- (void)didClicksettingBtn {
    BS;
}

- (void)didClickmoonBtn {
    BS;
}
@end
