//
//  BSRecTagController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/23.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecTagController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "BSRecTagModel.h"
#import <MJExtension.h>
#import "BSRecTagCell.h"

@interface BSRecTagController ()


@property (strong,nonatomic) NSArray *recTags;

@end

@implementation BSRecTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecTagCell class]) bundle:nil] forCellReuseIdentifier:@"recTag"];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BSGlobalColor;
}

- (void)loadData {
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"tag_recommend";
    paras[@"c"] = @"topic";
    paras[@"action"] = @"sub";
    
    // 发送请求获取数据
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

        // 模型数组
         self.recTags = [BSRecTagModel mj_objectArrayWithKeyValuesArray:responseObject];

        // 重新加载数据
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];

    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSRecTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recTag" forIndexPath:indexPath];
    
    cell.recTagModel = self.recTags[indexPath.row];

    return cell;
}

@end
