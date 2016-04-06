//
//  BSMeFooterView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/4.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSMeFooterView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BSSquaresModel.h"
#import "UIButton+WebCache.h"
#import "BSSqaureButton.h"
#import "BSWebViewController.h"

@implementation BSMeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        // 请求参数
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"a"] = @"square";
        paras[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           NSArray *squars = [BSSquaresModel mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            [self createSquares:squars];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *) squares {
    
    // 最大的列数
    int maxCols = 4;
    
    // 宽高
    CGFloat btnW = BSScreenW / maxCols;
    CGFloat btnH = btnW;
    
    for (int i = 0; i < squares.count; i++) {
        
        
        BSSqaureButton *btn = [BSSqaureButton buttonWithType:UIButtonTypeCustom];
//        [btn sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
//        [btn setTitle:square.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.square =squares[i];

        [self addSubview:btn];
        
        // 行列
        int col = i % maxCols;
        int row = i / maxCols;
        
        btn.x = col * btnW;
        btn.y = row * btnH;
        btn.width = btnW;
        btn.height = btnH;
        
    }
    
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;
    
    self.height = rows * btnH;


    [self setNeedsDisplay];
    
}
- (void)buttonClick:(BSSqaureButton *)button {
    
    if (![button.square.url hasPrefix:@"http"]) return;

    BSWebViewController *web = [[BSWebViewController alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;
    
    // 取出当前导航控制器
    UITabBarController *tabBarVC = (UITabBarController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *navVC = (UINavigationController *)tabBarVC.selectedViewController;
    [navVC pushViewController:web animated:YES];
        

}


@end
