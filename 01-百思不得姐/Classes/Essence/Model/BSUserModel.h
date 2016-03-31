//
//  BSUserModel.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/30.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUserModel : NSObject

// 头像
@property (nonatomic,copy) NSString *profile_image;
// 性别
@property (nonatomic,copy) NSString *sex;
// 用户名
@property (nonatomic,copy) NSString *username;

@end
