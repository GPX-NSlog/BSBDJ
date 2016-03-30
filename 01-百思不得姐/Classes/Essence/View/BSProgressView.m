//
//  BSProgressView.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/27.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSProgressView.h"

@implementation BSProgressView

- (void)awakeFromNib {

    self.roundedCorners = 3;
    self.progressLabel.textColor = [UIColor whiteColor];
}


- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [super setProgress:progress animated:animated];
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
   

}
@end
