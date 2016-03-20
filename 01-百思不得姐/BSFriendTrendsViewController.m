//
//  BSFriendTrendsViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSFriendTrendsViewController.h"

@interface BSFriendTrendsViewController ()

@end

@implementation BSFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImg:@"friendsRecommentIcon" highlight:@"friendsRecommentIcon-click" target:self action:@selector(didClickfriendsRecBtn)];
    
}
- (void)didClickfriendsRecBtn {
    BS;
}



@end
