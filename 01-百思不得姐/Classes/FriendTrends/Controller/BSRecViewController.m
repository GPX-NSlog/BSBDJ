//
//  BSRecViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "BSRecCategoryCell.h"
#import "BSRecCategoryModel.h"
#import "BSRecUserModel.h"
#import "BSRecUserCell.h"
#import <MJRefresh.h>

#define BSSelectedCate self.categorys[self.CategoryTabelView.indexPathForSelectedRow.row]

@interface BSRecViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *CategoryTabelView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@property (strong,nonatomic) NSArray *categorys;
@property (strong,nonatomic) NSArray *users;

@property (strong,nonatomic) NSDictionary *paras;


@property (strong,nonatomic) AFHTTPSessionManager *manager;
@end

static NSString *const BSCategroyCellID = @"categroy";
static NSString *const BSUserCellID = @"userID";


@implementation BSRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tabelView
    [self setupTabelView];
    
    // 初始化refresh
    [self setupRefresh];

    // 加载左侧类别数据
    [self loadCategories];
}
- (void)loadCategories {
    
    [SVProgressHUD show];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 关闭hud
        [SVProgressHUD dismiss];
        
        self.categorys = [BSRecCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.CategoryTabelView reloadData];
        
        [self.CategoryTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        // 进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求数据失败,请重试"];
    }];
}

#pragma mark -
#pragma mark 初始化tabView
- (void)setupTabelView {
    self.navigationItem.title = @"推荐关注";
    // 设置背景
    [self.view setBackgroundColor:BSGlobalColor];
    
    //注册单元格
    [self.CategoryTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecCategoryCell class]) bundle:nil] forCellReuseIdentifier:BSCategroyCellID];
   
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecUserCell class]) bundle:nil] forCellReuseIdentifier:BSUserCellID];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.CategoryTabelView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.CategoryTabelView.contentInset;
    self.userTableView.rowHeight = 70;
}

#pragma mark -
#pragma mark 刷新控件
- (void)setupRefresh {
    
    // 添加下拉刷新
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUser)];
    
    // 添加上拉刷新
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];


    self.userTableView.mj_footer.hidden = YES;

}

#pragma mark -
#pragma mark 加载数据
- (void)loadMoreUsers {
    BSRecCategoryModel *cateModel = BSSelectedCate;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"list";
    paras[@"c"] = @"subscribe";
    paras[@"category_id"] = @([BSSelectedCate id]);
    paras[@"page"] = @(++cateModel.currentPage);
    self.paras = paras;
    // 发送请求获取数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 转模型
        NSArray *users = [BSRecUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [cateModel.users addObjectsFromArray:users];
        if (self.paras != paras) return ;

        // 刷新右边表格
        [self.userTableView reloadData];
        
        // 加载结束刷新小菊花
        [self checkFooterState];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        [self.userTableView.mj_footer endRefreshing];
        
    }];
}


- (void)loadNewUser {
    
    BSRecCategoryModel *rc = BSSelectedCate;
    
    rc.currentPage = 1;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"list";
    paras[@"c"] = @"subscribe";
    paras[@"category_id"] = @(rc.id);
    paras[@"page"] = @(rc.currentPage);
    self.paras = paras;
    
    // 发送请求获取数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        // 转模型
        NSArray *users = [BSRecUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 清除所有旧数据
        [rc.users removeAllObjects];
        
        // 添加到当前的类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];

        if (self.paras != paras) return ;
        
        // 刷新右边单元格
        [self.userTableView reloadData];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        // 底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        // 提醒
        [self.userTableView.mj_header endRefreshing];
    }];
}

- (void)checkFooterState {
    BSRecCategoryModel *rc = BSSelectedCate;
    
    // 每次刷新右边数据时,都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    // 让底部控件结束刷新
    if (rc.users.count == rc.total) {//全部数据加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没加载完毕
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark -
#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.CategoryTabelView)return self.categorys.count;

    [self checkFooterState];

    return [BSSelectedCate users].count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.CategoryTabelView) {
        BSRecCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategroyCellID forIndexPath:indexPath];
        BSRecCategoryModel *model = self.categorys[indexPath.row];
        
        cell.model = model;
        return cell;

    } else {
        BSRecUserCell *cell = [tableView dequeueReusableCellWithIdentifier:BSUserCellID forIndexPath:indexPath];


        cell.userModel = [BSSelectedCate users][indexPath.row];
        return cell;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
        BSRecCategoryModel *cateModel = self.categorys[indexPath.row];

        if (cateModel.users.count) {
            [self.userTableView reloadData];
        } else {
            
            [self.userTableView reloadData];
           
            [self.userTableView.mj_header beginRefreshing];
        }
}
- (void)dealloc {
    [self.manager.operationQueue cancelAllOperations];
}
#pragma mark -
#pragma mark mananger懒加载
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

@end
