//
//  BSShowPictureController.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/27.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSShowPictureController.h"
#import "BSTopicModel.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "BSProgressView.h"

@interface BSShowPictureController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BSProgressView *progressView;
@property (weak, nonatomic) UIImageView *imgView;


@end

@implementation BSShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];


    // 图片的宽高
    CGFloat pictureW = BSScreenW;
    CGFloat pictuerH = pictureW * self.topicModel.height / self.topicModel.width;
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imgView = imgView;
    
    // 点击图片
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtn)]];
 
    if (pictuerH > BSScreenH ) { // 图片高度大于屏幕尺寸
        imgView.frame = CGRectMake(0, 0, pictureW, pictuerH);
        self.scrollView.contentSize = CGSizeMake(0, pictuerH);
        
    } else { // 小于屏幕尺寸
        imgView.size = CGSizeMake(pictureW, pictuerH);
        
        imgView.centerY = BSScreenH * 0.5;
    }
    
    [self.scrollView addSubview:imgView];
    // 马上显示图片的下载进度
    [self.progressView setProgress:self.topicModel.pictureProgress animated:NO];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.topicModel.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [self.progressView setProgress:1.0 * receivedSize/expectedSize animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
}

- (IBAction)backBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePicture {
    if (self.imgView.image == nil) {
       
        [SVProgressHUD showErrorWithStatus:@"图片未下载完!"];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];

    }
}


@end
