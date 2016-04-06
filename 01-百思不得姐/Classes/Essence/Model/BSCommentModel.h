//
//  BSComment.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/30.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSUserModel;

@interface BSCommentModel : NSObject

@property (copy,nonatomic) NSString *ID;
// 评论内容
@property (nonatomic,copy) NSString *content;
// 点赞数
@property (nonatomic,assign) NSInteger like_count;
// 声音时长
@property (assign,nonatomic) NSInteger voicetime;
// 用户
@property (strong,nonatomic) BSUserModel *user;
// 声音评论
@property (nonatomic,copy) NSString *voiceuri;
@end
