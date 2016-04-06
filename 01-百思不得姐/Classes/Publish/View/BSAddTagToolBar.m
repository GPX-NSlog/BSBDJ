//
//  BSAddTagToolBar.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSAddTagToolBar.h"
#import "BSAddTagController.h"

@interface BSAddTagToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation BSAddTagToolBar

- (void)awakeFromNib {
    // 添加加号按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addBtn.size = addBtn.currentImage.size;
    addBtn.x = BSTopicCellMargin;
    [_topView addSubview:addBtn];
}

- (void)addBtnClick {
    BSAddTagController *addVC = [[BSAddTagController alloc] init];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    
    [nav pushViewController:addVC animated:YES];
    
}

@end
