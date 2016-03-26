//
//  BSTopicPictureView.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/26.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopicModel;

@interface BSTopicPictureView : UIView
+ (instancetype)pictureView;


@property (strong,nonatomic) BSTopicModel *topicModel;
@end
