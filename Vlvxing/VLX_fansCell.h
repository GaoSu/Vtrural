//
//  VLX_fansCell.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_fansModel.h"

@interface VLX_fansCell : UITableViewCell

@property (nonatomic,strong)UIImageView * headImgvw2;//头像
@property (nonatomic,strong)UILabel * nameLb2;//名字
@property (nonatomic,strong)UIImageView * sxeImgvw2;//性别

-(void)FillWithModel:(VLX_fansModel *)model;

@end
