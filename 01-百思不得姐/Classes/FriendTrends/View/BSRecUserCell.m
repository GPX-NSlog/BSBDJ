//
//  BSUserCell.m
//  01-百思不得姐
//
//  Created by GuoPengxiang on 16/3/21.
//  Copyright © 2016年 BatMan. All rights reserved.
//

#import "BSRecUserCell.h"
#import "BSRecUserModel.h"
#import <UIImageView+WebCache.h>
@interface BSRecUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;



@end

@implementation BSRecUserCell



- (void)awakeFromNib {

}

- (void)setUserModel:(BSRecUserModel *)userModel {
    _userModel = userModel;

    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:userModel.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.screenNameLabel.text = userModel.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%@人关注",userModel.fans_count];
    
}
@end
