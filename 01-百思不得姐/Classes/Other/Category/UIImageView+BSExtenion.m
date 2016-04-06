//
//  UIImageView+BSExtenion.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/4/3.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "UIImageView+BSExtenion.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (BSExtenion)
- (void)setHeader:(NSString *)url {
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholderImage;
    }];

}
@end
