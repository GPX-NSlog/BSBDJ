//
//  BSTopicModel.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/24.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTopicModel : NSObject
// 昵称
@property (nonatomic,copy) NSString *name;
// 头像
@property (nonatomic,copy) NSString *profile_image;
// 发布时间
@property (nonatomic,copy) NSString *create_time;
// 内容
@property (nonatomic,copy) NSString *text;
// 顶
@property (nonatomic,assign) NSInteger ding;
// 踩
@property (assign,nonatomic) NSInteger cai;
// 转发
@property (assign,nonatomic) NSInteger repost;
// 评论
@property (nonatomic,copy) NSString *comment;

@end
