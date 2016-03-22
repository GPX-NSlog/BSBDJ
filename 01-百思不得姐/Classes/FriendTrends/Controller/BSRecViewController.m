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
    [self setupTabelView];
    
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
#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.CategoryTabelView) {
        
        return self.categorys.count;
    } else {
        BSRecCategoryModel *cateModel = self.categorys[self.CategoryTabelView.indexPathForSelectedRow.row];
        return cateModel.users.count;
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

        BSRecCategoryModel *cateModel = self.categorys[self.CategoryTabelView.indexPathForSelectedRow.row];
        
        cell.userModel = cateModel.users[indexPath.row];
        return cell;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSRecCategoryModel *cateModel = self.categorys[indexPath.row];

    if (cateModel.users.count) {
        [self.uesrTableView reloadData];
    } else {
    
        if (tableView == self.CategoryTabelView) {
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            paras[@"a"] = @"list";
            paras[@"c"] = @"subscribe";
            paras[@"category_id"] = @(cateModel.id);
            
            [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                

                NSArray *users = [BSRecUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                
                [cateModel.users addObjectsFromArray:users];
                
                [self.uesrTableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
}

@end
