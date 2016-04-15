//
//  BSFriendTrendsViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSFriendTrendsViewController.h"
#import "BSRecViewController.h"
#import "BSLoginRegController.h"

@interface BSFriendTrendsViewController ()

@end

@implementation BSFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImg:@"friendsRecommentIcon" highlight:@"friendsRecommentIcon-click" target:self action:@selector(didClickfriendsRecBtn)];
    [self.view setBackgroundColor:BSGlobalColor];

}
- (void)didClickfriendsRecBtn {
    BSRecViewController *rec = [[BSRecViewController alloc] init];
    [self.navigationController pushViewController:rec animated:YES];
}

- (IBAction)didClickLoginRegBtn:(id)sender {

    [self presentViewController:[[BSLoginRegController alloc] init] animated:YES completion:nil];
}


@end
