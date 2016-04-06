//
//  BSTopicVideoView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/30.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicVideoView.h"
#import "BSTopicModel.h"
#import <UIImageView+WebCache.h>
#import "BSShowPictureController.h"

@interface BSTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end

@implementation BSTopicVideoView

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


- (void)setTopicModel:(BSTopicModel *)topicModel {
    
    _topicModel = topicModel;
    
    // 图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:topicModel.large_image]];
    
    // 时长
    NSInteger min = topicModel.videotime / 60;
    NSInteger sec = topicModel.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%ld播放",topicModel.playcount];
    
}


@end
