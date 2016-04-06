//
//  BSMeCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/4.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSMeCell.h"

@implementation BSMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        // 指示器
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 背景
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;

        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + BSTopicCellMargin;
    
}




@end
