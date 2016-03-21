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

@interface BSRecViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *CategoryTabelView;


@property (strong,nonatomic) NSArray *categories;
@end
static NSString *const BSCategroyCellID = @"categroy";

@implementation BSRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐关注";
    // 设置背景
    [self.view setBackgroundColor:BSGlobalColor];

    //注册单元格
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BSRecCategoryCell class]) bundle:nil];
    [self.CategoryTabelView registerNib:nib forCellReuseIdentifier:BSCategroyCellID];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 关闭hud
        [SVProgressHUD dismiss];
        
        self.categories = [BSRecCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        [self.CategoryTabelView reloadData];
        [self.CategoryTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求数据失败,请重试"];
    }];
    
    
}


#pragma mark -
#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSRecCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategroyCellID forIndexPath:indexPath];
    BSRecCategoryModel *model = self.categories[indexPath.row];

    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BSRecCategoryModel *model = self.categories[indexPath.row];
    BSLog(@"~~~%@",model.name);
}

@end
