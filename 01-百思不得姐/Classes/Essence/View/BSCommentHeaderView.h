//
//  BSCommentHeaderView.h
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/31.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSCommentHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@property (nonatomic,copy) NSString *title;

@end
