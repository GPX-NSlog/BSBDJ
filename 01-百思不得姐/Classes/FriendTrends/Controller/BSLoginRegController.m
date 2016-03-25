//
//  BSLoginRegController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/23.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSLoginRegController.h"

@interface BSLoginRegController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLayout;
@end

@implementation BSLoginRegController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)didClickLoginRegBtn:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    // 根据约束切换界面
    if (self.marginLayout.constant == 0) { // 显示注册界面
        self.marginLayout.constant = -self.view.width;
        sender.selected = YES;
    } else { // 显示登录界面
        self.marginLayout.constant = 0;
        sender.selected = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)didClickCloseBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
