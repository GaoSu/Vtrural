//
//  VLX_mine_gz_Cell.h
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_mine_gz_Model.h"
@interface VLX_mine_gz_Cell : UITableViewCell


@property (nonatomic,strong)UIImageView * headImgvw1;//头像
@property (nonatomic,strong)UILabel * nameLb1;//名字
@property (nonatomic,strong)UIImageView * sxeImgvw1;//性别

-(void)FillWithModel:(VLX_mine_gz_Model *)model;

@end
