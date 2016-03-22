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
@property (weak, nonatomic) IBOutlet UITableView *uesrTableView;

@property (strong,nonatomic) NSArray *categorys;
@property (strong,nonatomic) NSArray *users;

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


    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 关闭hud
        [SVProgressHUD dismiss];
        
        self.categorys = [BSRecCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        [self.CategoryTabelView reloadData];
        [self.CategoryTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
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
   
    [self.uesrTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecUserCell class]) bundle:nil] forCellReuseIdentifier:BSUserCellID];

    self.uesrTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    self.uesrTableView.rowHeight = 70;
}

#pragma mark -
#pragma mark 刷新控件
- (void)setupRefresh {
    
    self.uesrTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];


    self.uesrTableView.mj_footer.hidden = YES;

}

#pragma mark -
#pragma mark loadMoreUsers 
- (void)loadMoreUsers {
    BSRecCategoryModel *cateModel = BSSelectedCate;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"list";
    paras[@"c"] = @"subscribe";
    paras[@"category_id"] = @([BSSelectedCate id]);
    paras[@"page"] = @(++cateModel.currentPage);
    
    // 发送请求获取数据
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 转模型
        NSArray *users = [BSRecUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [cateModel.users addObjectsFromArray:users];
        
        [self.uesrTableView reloadData];
        
        // 加载结束刷新小菊花
        if (cateModel.users.count == cateModel.total) {
            [self.uesrTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.uesrTableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark -
#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.CategoryTabelView) {
        
        return self.categorys.count;
    } else {
        
        NSInteger count = [BSSelectedCate users].count;
        self.uesrTableView.mj_footer.hidden = (count == 0);
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.CategoryTabelView) {
        BSRecCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategroyCellID forIndexPath:indexPath];
        BSRecCategoryModel *model = self.categorys[indexPath.row];
        
        cell.model = model;
        return cell;

    } else {
        BSRecUserCell *cell = [tableView dequeueReusableCellWithIdentifier:BSUserCellID forIndexPath:indexPath];

//        BSRecCategoryModel *cateModel = self.categorys[self.CategoryTabelView.indexPathForSelectedRow.row];
        
        cell.userModel = [BSSelectedCate users][indexPath.row];
        return cell;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        BSRecCategoryModel *cateModel = self.categorys[indexPath.row];

        if (cateModel.users.count) {
            [self.uesrTableView reloadData];
        } else {
            
            [self.uesrTableView reloadData];
            
            cateModel.currentPage = 1;
            
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            paras[@"a"] = @"list";
            paras[@"c"] = @"subscribe";
            paras[@"category_id"] = @(cateModel.id);
            paras[@"page"] = @(cateModel.currentPage);
            
            // 发送请求获取数据
            [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                // 转模型
                NSArray *users = [BSRecUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                
                [cateModel.users addObjectsFromArray:users];
                
                // 保存总数
                cateModel.total = [responseObject[@"total"] integerValue];
                [self.uesrTableView reloadData];
                if (cateModel.currentPage == cateModel.total) {
                    [self.uesrTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                // 加载小菊花
                [self.uesrTableView.mj_footer beginRefreshing];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
}

@end
