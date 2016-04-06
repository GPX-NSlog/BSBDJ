//
//  BSWebViewController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/4.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSWebViewController.h"
#import "NJKWebViewProgress.h"

@interface BSWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NJKWebViewProgress *progress;
@end

@implementation BSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    
    self.progress.progressBlock = ^(float progress) {
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.goBack.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
