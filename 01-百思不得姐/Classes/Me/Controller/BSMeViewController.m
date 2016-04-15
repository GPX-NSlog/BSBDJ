//
//  BSMeViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSMeViewController.h"
#import "BSMeCell.h"
#import "BSMeFooterView.h"
#import "BSSettingController.h"

@interface BSMeViewController ()


@end

@implementation BSMeViewController

static NSString *meCellId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNav];
    
    // 设置tableView
    [self setupTableView];
}

// 设置导航栏
- (void)setupNav {
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImg:@"mine-setting-icon" highlight:@"mine-setting-icon-click" target:self action:@selector(didClicksettingBtn)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImg:@"mine-moon-icon" highlight:@"mine-moon-icon-click" target:self action:@selector(didClickmoonBtn)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    
}

// 设置tableview
- (void)setupTableView {

    // 背景
    [self.tableView setBackgroundColor:BSGlobalColor];
//    self.tableView.contentOffset = CGPointMake(BSScreenW, 1000);
    // 注册
    [self.tableView registerClass:[BSMeCell class] forCellReuseIdentifier:meCellId];
    
    // 取消选中效果

    // 设置headerView footerView
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BSTopicCellMargin;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(BSTopicCellMargin - 35, 0, 0, 0);

    self.tableView.tableFooterView = [[BSMeFooterView alloc] initWithFrame:CGRectMake(0, 0, BSScreenW, BSScreenH)];
//    self.tableView.tableFooterView = [[BSMeFooterView alloc] init];
    
    self.tableView.bouncesZoom = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BSMeCell *cell = [tableView dequeueReusableCellWithIdentifier:meCellId];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
        cell.textLabel.text = @"登录/注册";
    } else {

        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

- (void)didClicksettingBtn {
    
    [self.navigationController pushViewController:[[BSSettingController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)didClickmoonBtn {
    BSFunc;
}
@end
