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
@property (nonatomic,assign) NSInteger comment;
// sinaV
@property (assign,nonatomic,getter=isSina_V) NSInteger sina_v;
// 图片的高度
@property (assign,nonatomic) CGFloat height;
// 图片的宽度
@property (assign,nonatomic) CGFloat width;
// 图片尺寸
@property (strong,nonatomic) NSString *small_image;
@property (strong,nonatomic) NSString *middle_image;
@property (strong,nonatomic) NSString *large_image;
// 帖子类型
@property (assign,nonatomic) BSTopicType type;
// 音频时长
@property (assign,nonatomic) NSInteger voicetime;
// 视频时长
@property (assign,nonatomic) NSInteger videotime;
// 播放次数
@property (assign,nonatomic) NSInteger playcount;
/** 最热评论(期望这个数组中存放的是XMGComment模型) */
@property (nonatomic, strong) NSArray *top_cmt;



/**** 辅助属性 ****/
@property (assign,nonatomic,getter=isBigPicture) BOOL bigPicture;
// 图片的frame
@property (assign,nonatomic,readonly) CGRect pictureF;
// cell的高度
@property (assign,nonatomic,readonly) CGFloat cellHeight;
// 图片下载进度
@property (assign,nonatomic) CGFloat pictureProgress;
// 声音的frame
@property (assign,nonatomic,readonly) CGRect voiceF;
// 视频的frame
@property (assign,nonatomic,readonly) CGRect videoF;


@end
