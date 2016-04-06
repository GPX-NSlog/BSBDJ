//
//  BSAddTagController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSAddTagController.h"

@interface BSAddTagController ()


@property (weak,nonatomic) UIView *contentView;

@property (weak,nonatomic) UITextField *textField;

@property (weak,nonatomic) UIButton  *addBtn;


@end

@implementation BSAddTagController

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.height = 35;
        addBtn.width = self.contentView.width;
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        addBtn.contentEdgeInsets = UIEdgeInsetsMake(0, BSTopicCellMargin, 0, BSTopicCellMargin);
        addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addBtn.backgroundColor = BSRGBColor(74, 139, 209);
        [self.contentView addSubview:addBtn];
        _addBtn = addBtn;
    }
    return _addBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
}

- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];

}

- (void)done {
    BSFunc;
}
- (void)setupContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.x = BSTopicCellMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + BSTopicCellMargin;
    contentView.height = BSScreenH;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextField {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.width = BSScreenW;
    textField.height = 25;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)textDidChange {
    if (self.textField.hasText) { // 有文字
        
        // 显示添加标签
        self.addBtn.hidden = NO;
        self.addBtn.y = CGRectGetMaxY(self.textField.frame) + BSTopicCellMargin;
        [self.addBtn setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
    } else {
        self.addBtn.hidden = YES;
    }
}

- (void)addBtnClick {
    BSFunc;
}
@end
