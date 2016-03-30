//
//  BSTopicVideoView.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/30.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopicModel;

@interface BSTopicVideoView : UIView

+ (instancetype)videoView;

@property (strong,nonatomic) BSTopicModel *topicModel;

@end
