//
//  BSPublishController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/28.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSPublishController.h"
#import "BSVerticalButton.h"
#import "BSPostWordController.h"
#import <POP.h>
#import "BSNavigationController.h"

static CGFloat const BSAnimationDelay = 0.05;
static CGFloat const BSSpringFactor = 8;

@interface BSPublishController ()

@end

@implementation BSPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    [self setupUI];
}

// 取消
- (IBAction)cancelBtn:(id)sender {
    
    [self cancelWithCompletionBlock:nil];
}

- (void)setupUI {

    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 添加按钮
    int cols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat startX = 20;
    CGFloat xMargin = (BSScreenW - startX * 2 -buttonW * cols) / (cols -1);
    CGFloat buttonY = BSScreenH * 0.5 - buttonH;
   
    for (int i = 0; i<images.count; i++) {
        
        BSVerticalButton *button = [BSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.tag = i;
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        int row = i / cols; // 行
        int col = i % cols; // 列
  
        CGFloat buttonX = startX + (buttonW + xMargin) * col;
        CGFloat buttonEndY = buttonY + buttonH * row;
        CGFloat buttonBeginY = buttonEndY - BSScreenH;
        
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY,  buttonW, buttonH)];
        anim.springBounciness = BSSpringFactor;
        anim.springSpeed = BSSpringFactor;
        anim.beginTime = CACurrentMediaTime() + i * BSAnimationDelay;
        [button pop_addAnimation:anim forKey:nil];
       
    }
    
    // 标语
    UIImageView *slogan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:slogan];
    CGFloat centerX = BSScreenW * 0.5;
    CGFloat centerEndY = BSScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - BSScreenH;
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    // 起始位置
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    // 终止位置
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    // 弹簧效果
    anim.springBounciness = BSSpringFactor;
    // 动画速度
    anim.springSpeed = BSSpringFactor;
    // 延迟执行
    anim.beginTime = CACurrentMediaTime() + images.count * BSAnimationDelay;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        // 打开用户交互
        self.view.userInteractionEnabled = YES;
    }];
    [slogan pop_addAnimation:anim forKey:nil];
    
}
- (void)buttonClick:(UIButton *) button {
    [self cancelWithCompletionBlock:^{
        
        if (button.tag == 0) {
            NSLog(@"发视频");
        } else if (button.tag == 1) {
            NSLog(@"发图片");
        } else if (button.tag == 2) {
            
            
            BSPostWordController *postWord = [[BSPostWordController alloc] init];
            
            BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:postWord];
            
            
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:nav animated:YES completion:nil];
            
        }
    }];
}
// 执行退出动画
- (void)cancelWithCompletionBlock:(void(^)())comlietionBlock {

    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    for (int i = beginIndex; i < self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerEndY = subview.centerY +BSScreenH;
    
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerEndY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) *BSAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        
        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
        
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                !comlietionBlock ? : comlietionBlock();
            }];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self cancelWithCompletionBlock:nil];
}
@end
