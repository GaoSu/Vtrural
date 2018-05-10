//
//  VLX_guanzhuCell.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_guanzhuModel.h"

@interface VLX_guanzhuCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headImgvw1;//头像
@property (nonatomic,strong)UILabel * nameLb1;//名字
@property (nonatomic,strong)UIImageView * sxeImgvw1;//性别

-(void)FillWithModel:(VLX_guanzhuModel *)model;

@end
