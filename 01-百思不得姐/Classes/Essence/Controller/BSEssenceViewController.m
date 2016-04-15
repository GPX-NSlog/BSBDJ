//
//  BSEssenceViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/20.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSRecTagController.h"
#import "BSTopicViewController.h"


@interface BSEssenceViewController () <UIScrollViewDelegate>

@property (weak,nonatomic) UIView *indicatorView;
@property (weak,nonatomic) UIButton *selectedBtn;
@property (weak,nonatomic) UIScrollView *contentView;
@property (weak,nonatomic) UIView *titleView;
@end

@implementation BSEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏
    [self setupNav];

    // 设置子控制器
    [self setupChildVces];

    // 设置标签栏
    [self setupTitleView];

    // 底部的scrollView
    [self setupContentView];
    

}

// 设置标签栏
-(void)setupTitleView {
    // 添加标签
    UIView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.frame = CGRectMake(0, 64, self.view.width,35 );
    [titleView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.618]];
    [self.view addSubview:titleView];

   
    // 添加指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titleView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 添加按钮
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat btnW = titleView.width / titles.count;
    CGFloat btnH = titleView.height;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnW * i, 0, btnW, btnH);
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectedBtn = button;
            
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titleView addSubview:indicatorView];

}
- (void)didClickTitleBtn:(UIButton *)button {
    
    // 修改按钮状态
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    // 滚动
    CGPoint offest = self.contentView.contentOffset;
    offest.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offest animated:YES];
    

}

// 设置导航栏
- (void)setupNav {
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImg:@"MainTagSubIcon" highlight:@"MainTagSubIconClick" target:self action:@selector(didClickTagBtn)];
    [self.view setBackgroundColor:BSGlobalColor];
}

// 设置底部的scrollView
- (void)setupContentView {
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    self.contentView = contentView;
    contentView.frame = self.view.bounds;
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

// 设置子控制器
- (void)setupChildVces {
     BSTopicViewController *allVC = [[BSTopicViewController alloc] init];
    allVC.title = @"全部";
    allVC.type = BSTopicTypeAll;
    [self addChildViewController:allVC];
    
    BSTopicViewController *videoVC = [[BSTopicViewController alloc] init];
    videoVC.title = @"视频";
    videoVC.type = BSTopicTypeVideo;
    [self addChildViewController:videoVC];
    
    BSTopicViewController *voiceVC = [[BSTopicViewController alloc] init];
    voiceVC.title = @"声音";
    voiceVC.type = BSTopicTypeVoice;
    [self addChildViewController:voiceVC];
    
    BSTopicViewController *pictureVC = [[BSTopicViewController alloc] init];
    pictureVC.title = @"图片";
    pictureVC.type = BSTopicTypePicture;
    [self addChildViewController:pictureVC];
    
    BSTopicViewController *wordVC = [[BSTopicViewController alloc] init];
    wordVC.title = @"段子";
    wordVC.type = BSTopicTypeWord;
    [self addChildViewController:wordVC];
}

- (void)didClickTagBtn {
    [self.navigationController pushViewController:[[BSRecTagController alloc] init] animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 当前索引
    NSInteger index =  scrollView.contentOffset.x / scrollView.width;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self didClickTitleBtn:self.titleView.subviews[index]];
    
}



@end
