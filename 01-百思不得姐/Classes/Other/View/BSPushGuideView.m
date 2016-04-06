//
//  BSPushGuideView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/24.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSPushGuideView.h"

@implementation BSPushGuideView

+ (void)show {
    NSString *key = @"CFBundleShortVersionString";
    
    // 获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 获取沙盒中的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        BSPushGuideView *pushWindow = [BSPushGuideView viewFormXib];
        pushWindow.frame = window.bounds;
        [window addSubview:pushWindow];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)didClickRemoveBtn:(id)sender {
    
    [self removeFromSuperview];
}


@end
