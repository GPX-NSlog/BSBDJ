//
//  BSCommentCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/1.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSCommentCell.h"
#import "UIImageView+WebCache.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"

@interface BSCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;


@end


@implementation BSCommentCell

- (void)awakeFromNib {
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgImgView ;
}

// 设置数据
- (void)setComment:(BSCommentModel *)comment {
    _comment = comment;
    
    // 头像
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.profileImageView.image = [image circleImage];
//    }];
    
    [self.profileImageView setHeader:comment.user.profile_image];

    // 性别
    self.sexImgView.image = [comment.user.sex isEqualToString:BSUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"]: [UIImage imageNamed:@"Profile_womanIcon"];
    
    // 昵称
    self.usernameLabel.text = comment.user.username;
    
    // 点赞数
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",comment.like_count];
    
    // 评论内容
    self.contentLabel.text = comment.content;
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%ld",comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
    
}


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += BSTopicCellMargin;
    frame.size.width -= 2*BSTopicCellMargin;
    [super setFrame:frame];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}
@end
