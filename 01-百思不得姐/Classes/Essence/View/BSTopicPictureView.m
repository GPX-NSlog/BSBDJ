//
//  BSTopicPictureView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/26.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "BSTopicModel.h"
#import "DALabeledCircularProgressView.h"
#import "BSProgressView.h"
#import "BSShowPictureController.h"


@interface BSTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifImgView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet BSProgressView *progressView;
@end

@implementation BSTopicPictureView

- (void)setTopicModel:(BSTopicModel *)topicModel {

    [self.progressView setProgress:topicModel.pictureProgress animated:NO];
    
    _topicModel = topicModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:topicModel.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        // 下载进度
        topicModel.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topicModel.pictureProgress animated:NO];
        self.progressView.hidden = NO;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        if (topicModel.isBigPicture == NO) return ;
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topicModel.pictureF.size, YES, 0.0);
        // 将下载完的image对象绘制到图形上下文
        CGFloat width = topicModel.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];

        // 获得图片
        self.imgView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
    NSString *extension = topicModel.large_image.pathExtension;
    // 判断是否显示gif
    self.gifImgView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    // 判断是否显示按钮
    if (topicModel.isBigPicture) {
        self.seeBigBtn.hidden = NO;
//        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.seeBigBtn.hidden = YES;
//        self.seeBigBtn.contentMode = UIViewContentModeScaleToFill;

    }
    
}

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];

}

#pragma mark -
#pragma mark 显示图片
- (void)showPicture {
    
    BSShowPictureController *showPictuer = [[BSShowPictureController alloc] init];
    
    showPictuer.topicModel = self.topicModel;

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPictuer animated:YES completion:nil];

    
}


@end
