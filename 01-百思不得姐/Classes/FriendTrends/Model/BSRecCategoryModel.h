//
//  BSRecCategoryModel.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/21.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSRecUserModel;

@interface BSRecCategoryModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger count;
@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSMutableArray *users;

@property (nonatomic, assign) NSInteger currentPage;
@property (assign,nonatomic) NSInteger total;

@end
