//
//  BSRecCategoryModel.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/21.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecCategoryModel.h"

@implementation BSRecCategoryModel


#pragma mark -
#pragma mark users懒加载
- (NSMutableArray *)users {
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id",
             };
}

@end
