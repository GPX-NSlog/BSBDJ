//
//  BSTopicCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/25.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopicModel.h"
#import <UIImageView+WebCache.h>
#import "BSTopicPictureView.h"
#import "BSTopicVoiceView.h"
#import "BSTopicVideoView.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"

@interface BSTopicCell ()
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
// 顶
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
// 踩
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
// 分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
// 评论
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
// 新浪V
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImgView;
// 文字内容
@property (weak, nonatomic) IBOutlet UILabel *text_label;
// 图片
@property (weak, nonatomic) BSTopicPictureView *pictureView;
// 声音
@property (weak, nonatomic) BSTopicVoiceView *voiceView;
// 视频
@property (weak, nonatomic) BSTopicVideoView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;


@end

@implementation BSTopicCell

- (void)awakeFromNib {
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgImgView ;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setTopicModel:(BSTopicModel *)topicModel {
    _topicModel = topicModel;

    // sianV
    self.sinaVImgView.hidden = !topicModel.isSina_V;
    
    // 头像
//    [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:topicModel.profile_image] placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.profileImgView.image = [image circleImage];
//    }];
    
    [self.profileImgView setHeader:topicModel.profile_image];
    // 姓名
    self.nameLabel.text = topicModel.name;
    // 时间
    self.timeLable.text = topicModel.create_time;
    // 内容
    self.text_label.text = topicModel.text;

    // 按钮
    [self setupBtnTitle:self.dingBtn count:topicModel.ding placeholder:@"顶"];
    [self setupBtnTitle:self.caiBtn count:topicModel.cai placeholder:@"踩"];
    [self setupBtnTitle:self.shareBtn count:topicModel.repost placeholder:@"分享"];
    [self setupBtnTitle:self.commentBtn count:topicModel.comment placeholder:@"评论"];

    if (topicModel.type == BSTopicTypePicture) { // 图片帖子
        self.pictureView.topicModel = topicModel;
        self.pictureView.frame = topicModel.pictureF;
        
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        
    } else if (topicModel.type == BSTopicTypeVoice) { // 声音帖子
        self.voiceView.topicModel = topicModel;
        self.voiceView.frame = topicModel.voiceF;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        
    } else if (topicModel.type == BSTopicTypeVideo) { // 视频帖子
        
        self.videoView.topicModel = topicModel;
        self.videoView.frame = topicModel.voiceF;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
    } else {
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    BSCommentModel *cmt = topicModel.top_cmt;
    if (cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",cmt.user.username,cmt.content];
    } else {
        self.topCmtView.hidden = YES;
    }
}

- (void)setupBtnTitle:(UIButton *) btn count:(NSInteger )count placeholder:(NSString *) placeholder{
    
    if (count > 10000) {
        [btn setTitle:[NSString stringWithFormat:@"%.lf万",count / 10000.0] forState:UIControlStateNormal];
    } else if (count > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
    } else {
        [btn setTitle:placeholder forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)more:(id)sender {
    
    UIAlertController *aleartController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *jbAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:nil];
    [aleartController addAction:addAction];
    [aleartController addAction:jbAction];
    [aleartController addAction:cancelAction];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aleartController animated:YES completion:nil];
}

// 设置内边距
- (void)setFrame:(CGRect)frame {

    frame.origin.x = BSTopicCellMargin;
    frame.size.width -= 2 * BSTopicCellMargin;
    frame.size.height = self.topicModel.cellHeight - BSTopicCellMargin;
    frame.origin.y += BSTopicCellMargin;
    
    [super setFrame:frame];
}

#pragma mark -
#pragma mark pictureView懒加载
- (BSTopicPictureView *)pictureView {
    if (_pictureView == nil) {
        BSTopicPictureView *pictureView = [BSTopicPictureView viewFormXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
#pragma mark -
#pragma mark voiceView懒加载
- (BSTopicVoiceView *)voiceView {
    if (_voiceView == nil) {
        BSTopicVoiceView *voiceView = [BSTopicVoiceView viewFormXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
#pragma mark -
#pragma mark videoView懒加载
- (BSTopicVideoView *)videoView {
    if (_videoView == nil) {
        BSTopicVideoView *videoView= [BSTopicVideoView viewFormXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;

}
@end
