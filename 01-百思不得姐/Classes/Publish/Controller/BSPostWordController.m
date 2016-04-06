//
//  BSPostWordController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/5.
//  Copyright © 2016年 BatMan. All rights reserved.
//



#import "BSPostWordController.h"
#import "BSPlaceholderTextView.h"
#import "BSAddTagToolBar.h"

@interface BSPostWordController ()<UITextViewDelegate>
// 输入控件
@property (weak,nonatomic) BSPlaceholderTextView *textView;
// 工具条
@property (nonatomic, weak) BSAddTagToolBar *toolbar;

@end

@implementation BSPostWordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolBar];
    
}

- (void)setupNav {
    
    self.title = @"发表文字";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    // 强制刷新
    
    [self.navigationController.navigationBar layoutIfNeeded];
    
}

- (void)setupTextView {
    
    BSPlaceholderTextView *textView = [[BSPlaceholderTextView alloc] init];
    
    textView.frame = self.view.bounds;
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    
    [self.view addSubview:textView];
    textView.delegate = self;
    self.textView = textView;
}

- (void)setupToolBar {
    
    BSAddTagToolBar *toolBar = [BSAddTagToolBar viewFormXib];
    toolBar.width = self.view.width;
    toolBar.y = self.view.height - toolBar.height;
    [self.view addSubview:toolBar];
    self.toolbar = toolBar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
// 监听键盘的弹出和隐藏
- (void)keyboardWillChangeFrame:(NSNotification *)note {

    CGRect keyBoardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画时间
    CGFloat duration = [note.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
       
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyBoardF.origin.y - BSScreenH);
    }];
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)post {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];

}
@end

