 //
//  BSCommentHeaderView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/31.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSCommentHeaderView.h"

@interface BSCommentHeaderView ()

@property (weak,nonatomic) UILabel *label;

@end


@implementation BSCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
     
        self.contentView.backgroundColor = BSGlobalColor;
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = BSRGBColor(67, 67, 67);
        label.width = 200;
        label.x = BSTopicCellMargin;
        label.font = [UIFont systemFontOfSize:14];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
        
    }
    return self;
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    BSCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[BSCommentHeaderView alloc] initWithReuseIdentifier:ID];
        
    }
    return header;
}

-(void)setTitle:(NSString *)title {

    _title = [title copy];

    self.label.text = title;
}
@end
