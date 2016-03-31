//
//  BSTopicModel.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/24.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicModel.h"
#import "NSDate+BSExtension.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"


@interface BSTopicModel ()


@end

@implementation BSTopicModel {

    CGFloat _cellHeight;
//    CGRect _pictureF;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2"};
    
}
+ (NSDictionary *)objectClassInArray
{
    //    return @{@"top_cmt" : [XMGComment class]};
    return @{@"top_cmt" : @"BSCommentModel"};
}
- (NSString *)create_time {
    
    // 日期格式化类
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    // 日期格式
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *create = [df dateFromString:_create_time];
    
    if (create.isThisYear) {
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            if (cmps.hour > 1) { // 1小时已上
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            } else if (cmps.minute > 0) { // 1小时内
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            } else {
                return @"刚刚";
            }
        }else if (create.isYesterday) {// 昨天
            df.dateFormat = @"昨天 HH:mm:ss";
            return [df stringFromDate:create];
        } else { // 其他
            df.dateFormat = @"MM-dd HH:mm:ss";
            return [df stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }

}

- (CGFloat)cellHeight {
    
    if (!_cellHeight) {
        // 文字最大尺寸
        CGSize maxSize = CGSizeMake(BSScreenW - 4 * BSTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        // 文字部分的高度
        _cellHeight = BSTopicCellTextY + textH + BSTopicCellMargin;

        if (self.type == BSTopicTypePicture) { // 图片
            CGFloat pictureW = maxSize.width;
            CGFloat pictureH = self.height * pictureW / self.width;
            
            if (pictureH >= BSTopicCellPictureMaxH) {
                pictureH = BSTopicCellPictureMaxShowH;
                self.bigPicture = YES;
            }
            
            CGFloat pictureX = BSTopicCellMargin;
            CGFloat pictureY = BSTopicCellTextY + textH + BSTopicCellMargin;
            
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            _cellHeight += pictureH + BSTopicCellMargin;


        } else if (self.type == BSTopicTypeVoice) { // 声音
            
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = self.height * voiceW / self.width;
            
            CGFloat voiceX = BSTopicCellMargin;
            CGFloat voiceY = BSTopicCellTextY + textH + BSTopicCellMargin;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + BSTopicCellMargin;
        } else if (self.type == BSTopicTypeVideo) {
            CGFloat videoW = maxSize.width;
            CGFloat videoH = self.height * videoW / self.width;
            
            CGFloat videoX = BSTopicCellMargin;
            CGFloat videoY = BSTopicCellTextY + textH + BSTopicCellMargin;
            _voiceF = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + BSTopicCellMargin;
            
        }
        
        // 如果有热门评论
        BSCommentModel *cmt = [self.top_cmt firstObject];
        if (cmt) {
            
            NSString *content = [NSString stringWithFormat:@"%@ : %@",cmt.user.username,cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            
            _cellHeight += BSTopicCellTopCmtTitleH + contentH +BSTopicCellMargin;

        }
       _cellHeight += BSTopicCellBottomBarH + BSTopicCellMargin;
    }

    // 底部工具条
    return _cellHeight;
    
}

@end
