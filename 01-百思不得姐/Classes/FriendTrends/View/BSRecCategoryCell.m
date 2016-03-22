//
//  BSRecCategoryCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/21.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecCategoryCell.h"
#import "BSRecCategoryModel.h"

@interface BSRecCategoryCell ()
@property (weak, nonatomic) IBOutlet UIView *leftView;

@end

@implementation BSRecCategoryCell

- (void)awakeFromNib {
    self.backgroundColor = BSRGBColor(244, 244, 244);
//    self.textLabel.textColor = BSRGBColor(78, 78, 78);
//    self.textLabel.highlightedTextColor = BSRGBColor(219, 21, 26);
}

- (void)setModel:(BSRecCategoryModel *)model {
    _model = model;

    self.textLabel.text = model.name;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.leftView.hidden = !selected;
    self.textLabel.textColor = selected ? self.leftView.backgroundColor :  BSRGBColor(78, 78, 78);
}
@end
