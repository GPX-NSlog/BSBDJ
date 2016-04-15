//
//  BSAddTagController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSAddTagController.h"
#import "BSTagButton.h"
#import "BSTagTextField.h"
#import "SVProgressHUD.h"

@interface BSAddTagController ()<UITextFieldDelegate>


@property (weak,nonatomic) UIView *contentView;

@property (weak,nonatomic) BSTagTextField *textField;

@property (weak,nonatomic) UIButton  *addBtn;


@property (strong,nonatomic) NSMutableArray *tagBtns;

@end

@implementation BSAddTagController

#pragma mark - 懒加载
- (NSMutableArray *)tagBtns {
    if (_tagBtns == nil) {
        _tagBtns = [NSMutableArray array];
    }
    return _tagBtns;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.height = 35;
        addBtn.width = self.contentView.width;
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = BSTagFont;
        addBtn.contentEdgeInsets = UIEdgeInsetsMake(0, BSTopicCellMargin, 0, BSTopicCellMargin);
        addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addBtn.backgroundColor = BSTagBtnColor;
        [self.contentView addSubview:addBtn];
        _addBtn = addBtn;
    }
    return _addBtn;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] init];
        [self.view addSubview:contentView];
        self.contentView = contentView;
    }
    return _contentView;
}


- (BSTagTextField *)textField {
    if (_textField == nil) {
        
        __weak typeof (self) weakSelf = self;
        BSTagTextField *textField = [[BSTagTextField alloc] init];
       
        textField.deleteBlock = ^{
            if (weakSelf.textField.hasText) return ;
            [weakSelf tagBtnClick:[weakSelf.tagBtns lastObject]];
        };
        textField.delegate = self;
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [textField becomeFirstResponder];
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return _textField;
}


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
}
- (void)setupTags {
    if (self.tags.count) {
        for (NSString *tag in self.tags) {
            self.textField.text = tag;
            [self addBtnClick];
        }
        self.tags = nil;
    }
}

- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.contentView.x = BSTagBtnMargin;
    self.contentView.width = self.view.width - 2 * self.contentView.x;
    self.contentView.y = 64 + BSTopicCellMargin;
    self.contentView.height = BSScreenH;
    
    self.textField.width = self.contentView.width;
    
    self.addBtn.width = self.contentView.width;
    
    [self setupTags];
}



- (void)done {
    
    NSArray *tags = [self.tagBtns valueForKeyPath:@"currentTitle"];
    
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 监听文字改变
- (void)textDidChange {
    
    // 更新标签frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) { // 有文字
        
        // 显示添加标签
        self.addBtn.hidden = NO;
        self.addBtn.y = CGRectGetMaxY(self.textField.frame) + BSTopicCellMargin;
        [self.addBtn setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
        NSString *text = self.textField.text;
        NSString *lastChar = [text substringFromIndex:text.length - 1];
        if (([lastChar isEqualToString:@"," ] || [lastChar isEqualToString:@"，"])&& text.length > 1) {
            self.textField.text = [text substringToIndex:text.length - 1];
            [self addBtnClick];
        }

    } else {
        self.addBtn.hidden = YES;
    }

}
// 添加标签
- (void)addBtnClick {
    
    if (self.tagBtns.count >= 5) {
        [SVProgressHUD showErrorWithStatus:@"已经有5个标签了"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    BSTagButton *tagBtn = [BSTagButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setTitle:self.textField.text forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagBtns addObject:tagBtn];
    [self.contentView addSubview:tagBtn];

    // 清空
    self.textField.text = nil;
    self.addBtn.hidden = YES;
    
    [self updateTagBtnFrame];
    [self updateTextFieldFrame];
}

#pragma mark - 按钮点击
//移除标签按钮
- (void)tagBtnClick:(BSTagButton *)tagBtn {
    [tagBtn removeFromSuperview];
    [self.tagBtns removeObject:tagBtn];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self updateTagBtnFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 控件Frame
// 更新标签按钮的frame
- (void)updateTagBtnFrame {

    for (int i = 0; i < self.tagBtns.count; i++) {
        
        BSTagButton *tagBtn = self.tagBtns[i];
        if (i == 0) { // 第一个按钮
            tagBtn.x = 0;
            tagBtn.y = 0;
        } else { // 其他按钮
            BSTagButton *lastBtn = self.tagBtns[i-1];
            CGFloat leftWidth = CGRectGetMaxX(lastBtn.frame) + BSTagBtnMargin;
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagBtn.width) { // 按钮宽度小于剩余宽度

                tagBtn.x = leftWidth;
                tagBtn.y = lastBtn.y;
                
            } else { // 大于剩余宽度
            
                tagBtn.x = 0;
                tagBtn.y = CGRectGetMaxY(lastBtn.frame) + BSTagBtnMargin;
            }
            
        }
        
    }
  
}

- (void)updateTextFieldFrame {
    // 更新textField的frame
    BSTagButton *lastBtn = [self.tagBtns lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastBtn.frame) + BSTagBtnMargin;
    //        CGFloat rightWidth = self.contentView.width - leftWidth;
    if (self.contentView.width - leftWidth >= [self textFiledWidth]) { // textField宽度小于剩余宽度
        self.textField.x = leftWidth;
        self.textField.y = lastBtn.y;
    } else { // 大于
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastBtn.frame) + BSTagBtnMargin;
        
    }
    
    self.addBtn.y = CGRectGetMaxY(self.textField.frame) + BSTagBtnMargin;

}

// textField的宽度
- (CGFloat)textFiledWidth {
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.textField.hasText) {
        [self addBtnClick];
    }
    
    return YES;
}
@end
