//
//  BSTopicModel.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/24.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicModel.h"
#import "NSDate+BSExtension.h"


@interface BSTopicModel ()


@end

@implementation BSTopicModel {

    CGFloat _cellHeight;
    CGRect _pictureF;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2"};
    
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
                return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
            } else if (cmps.minute > 0) { // 1小时内
                return [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
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
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * BSTopicCellMargin, MAXFLOAT);
    
    CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    // 文字部分的高度
    _cellHeight = BSTopicCellTextY + textH + BSTopicCellMargin;
    if (self.type == BSTopicTypePicture) {
        CGFloat pictureW = maxSize.width;
        CGFloat pictureH = self.height * pictureW / self.width;
        CGFloat pictureX = BSTopicCellMargin;
        CGFloat pictureY = BSTopicCellTextY + textH + BSTopicCellMargin;
        if (pictureH >= BSTopicCellPictureMaxH) {
            pictureH = BSTopicCellPictureMaxShowH;
            self.bigPicture = YES;
        }
        
        _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
        _cellHeight += pictureH + BSTopicCellMargin;
    }
    // 底部工具条
    return _cellHeight + BSTopicCellBottomBarH + BSTopicCellMargin;
}



@end
