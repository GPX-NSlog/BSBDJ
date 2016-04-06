//
//  BSAddTagToolBar.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSAddTagToolBar.h"
#import "BSAddTagController.h"

@interface BSAddTagToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

/** 添加按钮 */
@property (weak, nonatomic) UIButton *addBtn;
/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

@end

@implementation BSAddTagToolBar

- (NSMutableArray *)tagLabels {
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib {
    // 添加加号按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addBtn.size = addBtn.currentImage.size;
    addBtn.x = BSTopicCellMargin;
    [_topView addSubview:addBtn];
    self.addBtn = addBtn;
}

- (void)addBtnClick {
    BSAddTagController *addVC = [[BSAddTagController alloc] init];
  
    __weak typeof (self) weakSelf = self;
    [addVC setTagsBlock:^(NSArray *tags) {
        [weakSelf creteTags:tags];
    }];
    addVC.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    
    [nav pushViewController:addVC animated:YES];
    
}
- (void)creteTags:(NSArray *)tags {
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects ];
    for (int  i = 0 ; i < tags.count; i++ ) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = BSTagBtnColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = BSTagFont;
        // 先设置文字和字体后,在进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * BSTagBtnMargin;
        tagLabel.height = BSTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
       
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + BSTagBtnMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + BSTagBtnMargin;
            }
        }
    }
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + BSTagBtnMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addBtn.width) {
        self.addBtn.y = lastTagLabel.y;
        self.addBtn.x = leftWidth;
    } else {
        self.addBtn.x = 0;
        self.addBtn.y = CGRectGetMaxY(lastTagLabel.frame) + BSTagBtnMargin;
    }

}
@end
