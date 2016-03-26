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

@interface BSTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifImgView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation BSTopicPictureView
+ (instancetype)pictureView {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setTopicModel:(BSTopicModel *)topicModel {

    _topicModel = topicModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:topicModel.large_image] placeholderImage:nil];
    NSString *extension = topicModel.large_image.pathExtension;
    // 判断是否显示gif
    self.gifImgView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    // 判断是否显示按钮
    if (topicModel.isBigPicture) {
        self.seeBigBtn.hidden = NO;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.seeBigBtn.hidden = YES;
        self.seeBigBtn.contentMode = UIViewContentModeScaleToFill;

    }
    
}

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
