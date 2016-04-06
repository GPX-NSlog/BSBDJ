//
//  BSCommentController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/31.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSCommentController.h"
#import "BSTopicCell.h"
#import "BSTopicModel.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BSCommentModel.h"
#import "MJRefresh.h"
#import "BSCommentHeaderView.h"
#import "BSCommentCell.h"

@interface BSCommentController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
// 保存帖子的top_cmt
@property (strong,nonatomic) BSCommentModel *saved_top_cmt;
// 保存当前页码
@property (assign,nonatomic) NSInteger page;
// 管理者

@property (strong,nonatomic) AFHTTPSessionManager *manager;


@end

static NSString *const BSCommentId = @"commentCell";

@implementation BSCommentController


#pragma mark -
#pragma mark manager懒加载
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setupBasic];
    
    // 评论头视图
    [self setupHeaderView];
    
    // 加载数据
    [self setupRefresh];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadNewComments {
    
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return ;
        } // 说明没有数据
        
        // 最热评论
        self.hotComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
//         最新评论
        self.latestComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            self.tableView.mj_footer.hidden = YES;
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        
    }];
    

}

- (void)loadMoreComments {
    
    // 结束之前分所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 页码
    NSInteger page = self.page;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    BSCommentModel *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return ;
        } // 说明没有数据
        
        // 最新评论
        NSArray *newComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        self.page = page;
        
        // 刷新
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            self.tableView.mj_footer.hidden = YES;
            
        } else {
            [self.tableView.mj_footer  endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        
    }];
    

}


- (void)setupHeaderView {
    
    // 清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 创建头视图
    UIView *headerView = [[UIView alloc] init];
    // 添加cell
    BSTopicCell *cell = [BSTopicCell viewFormXib];
    [headerView addSubview:cell];
    // 传递数据
    cell.topicModel = self.topic;
    // 设置高度
    cell.size = CGSizeMake(BSScreenW, self.topic.cellHeight);
    headerView.height = self.topic.cellHeight + BSTopicCellMargin;
    // 头视图
    self.tableView.tableHeaderView = headerView;

}

// 基本设置
- (void)setupBasic {
    self.title = @"评论";
    self.tableView.backgroundColor = BSGlobalColor;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImg:@"comment_nav_item_share_icon" highlight:@"comment_nav_item_share_icon_click" target:self action:nil];
    // 键盘高度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSCommentCell class]) bundle:nil] forCellReuseIdentifier:BSCommentId];
    
    // 设置高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, BSTopicCellMargin, 0);

}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
   
    // 键盘显示/隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 修改底部约束
    self.bottomSapce.constant = BSScreenH - frame.origin.y;
    
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 清空top_cmt
    if (self.topic.top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    [self.manager invalidateSessionCancelingTasks:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    // 隐藏尾部空间
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (hotCount) return 2;// 有最热评论
    if (latestCount) return 1; // 有最新评论
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (section == 0) return hotCount ? hotCount : latestCount;
    
    return latestCount;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCommentId];
    
    cell.comment = [self commentInIndexPath:indexPath];

    
    return cell;
}
// 返回第section组的所有评论
- (NSArray *)commentsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}
- (BSCommentModel *)commentInIndexPath:(NSIndexPath *)indexPath {
   
    return [self commentsInSection:indexPath.section][indexPath.row];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    BSCommentHeaderView *header = [BSCommentHeaderView headerViewWithTableView:tableView];
    
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    }
    else {
        header.title = @"最新评论";
    }
    
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 成为第一响应者
    [cell becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    
    [menu setMenuItems:@[ding,replay,report]];
    
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
    [menu setTargetRect:rect inView:cell];
    [menu setMenuVisible:YES animated:YES];
}
- (void)ding:(UIMenuController *)menu {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@",[self commentInIndexPath:indexPath].content);
    BSFunc;
}
- (void)replay:(UIMenuController *)menu {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@",[self commentInIndexPath:indexPath].content);
    BSFunc;
}
- (void)report:(UIMenuController *)menu {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@",[self commentInIndexPath:indexPath].content);
    BSFunc;
}
@end
