//
//  BSRecTagCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/23.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecTagCell.h"
#import "BSRecTagModel.h"
#import <UIImageView+WebCache.h>

@interface BSRecTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_list;

@property (weak, nonatomic) IBOutlet UILabel *theme_name;
@property (weak, nonatomic) IBOutlet UILabel *sub_number;

@end

@implementation BSRecTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecTagModel:(BSRecTagModel *)recTagModel {
    _recTagModel = recTagModel;
    [self.image_list sd_setImageWithURL:[NSURL URLWithString:recTagModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.theme_name.text = recTagModel.theme_name;
    
    if (recTagModel.sub_number > 10000) {
        self.sub_number.text = [NSString stringWithFormat:@"%.1f万人订阅",recTagModel.sub_number/10000.0];
    } else {
        self.sub_number.text = [NSString stringWithFormat:@"%ld人订阅",(long)recTagModel.sub_number];
    }
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
    
}

@end
