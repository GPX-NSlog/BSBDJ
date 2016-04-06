//
//  BSTopicViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/24.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "BSTopicModel.h"
#import <MJRefresh.h>
#import "BSTopicCell.h"
#import "BSCommentController.h"
#import "BSNewViewController.h"

@interface BSTopicViewController ()

@property (strong,nonatomic) NSMutableArray *topics;

@property (assign,nonatomic) NSInteger page;

@property (copy,nonatomic) NSString *maxtime;

@property (strong,nonatomic) NSDictionary *paras;

@property (assign,nonatomic) NSInteger lastSelectedIndex;

@end

@implementation BSTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    // 加载帖子
    [self loadNewTopics];

    // 加载刷新控件
    [self setupRefresh];
}


static NSString * const BSTopicCellID = @"topicCell";

- (void)setupTableView {
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = BSTitilesViewH + BSTitilesViewY;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 背景
    self.tableView.backgroundColor = [UIColor clearColor];

    // 加载xib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:BSTopicCellID];
    
    // 监听tabbar点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelect) name:BSTabBarDidSelectNotification object:nil];
    
}
- (void)tabbarSelect {
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}


#pragma mark -
#pragma mark a参数
- (NSString *)a {

    return [self.parentViewController isKindOfClass:[BSNewViewController class]] ? @"newlist" : @"list";
}


// 加载新的数据
- (void)loadNewTopics{
    
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = self.a;
    paras[@"c"] = @"data";
    paras[@"type"] = @(self.type);
    paras[@"maxtime"] = @"maxtime";
    self.paras = paras;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 如果请求参数不同技术刷新
        if (self.paras != paras) return;
        [responseObject writeToFile:@"/Users/Gpx/Desktop/Snip20160323.plist" atomically:YES];

        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        // 字典转模型
        self.topics = [BSTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        // 回到加载第一页数据
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)loadMoreTopics {
    
    [self.tableView.mj_header endRefreshing];
    self.page++;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = self.a;
    paras[@"c"] = @"data";
    paras[@"type"] = @(self.type);
    paras[@"page"] = @(self.page);
    paras[@"maxtime"] = self.maxtime;
    self.paras = paras;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 如果请求参数不同技术刷新
        if (self.paras != paras) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典转模型
        NSArray  *newTopics = [BSTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 修复页码
        self.page--;
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BSTopicCellID forIndexPath:indexPath];
    
    BSTopicModel *model= self.topics[indexPath.row];
    cell.topicModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    BSTopicModel *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSCommentController *cmVC = [[BSCommentController alloc] init];
    
    cmVC.topic = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:cmVC animated:YES];
}
#pragma mark -
#pragma mark topics懒加载
- (NSMutableArray *)topics {
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

@end
