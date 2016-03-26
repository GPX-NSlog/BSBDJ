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

@interface BSTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImgView;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (weak, nonatomic) BSTopicPictureView *pictureView;
@end

@implementation BSTopicCell

- (void)awakeFromNib {
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
    
    self.backgroundView = bgImgView ;
}

- (void)setTopicModel:(BSTopicModel *)topicModel {
    _topicModel = topicModel;

    // sianV
    self.sinaVImgView.hidden = !topicModel.isSina_V;
    
    // 头像
    [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:topicModel.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
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

    if (topicModel.type == BSTopicTypePicture) {
        self.pictureView.topicModel = topicModel;
        self.pictureView.frame = topicModel.pictureF;
    }
    
    
}

- (void)setupBtnTitle:(UIButton *) btn count:(NSInteger )count placeholder:(NSString *) placeholder{
    
    if (count > 10000) {
        [btn setTitle:[NSString stringWithFormat:@"%.lf万",count / 10000.0] forState:UIControlStateNormal];
    } else if (count > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
    } else {
        [btn setTitle:placeholder forState:UIControlStateNormal];
    }
    
    
}

// 设置内边距
- (void)setFrame:(CGRect)frame {

    static CGFloat margin = 5;
    frame.origin.x += margin;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

#pragma mark -
#pragma mark pictureView懒加载
- (BSTopicPictureView *)pictureView {
    if (_pictureView == nil) {
        BSTopicPictureView *pictureView = [BSTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

@end
