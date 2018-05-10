//
//  VLX_mine_fensi_cell.h
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_mine_fensi_model.h"


@interface VLX_mine_fensi_cell : UITableViewCell

@property (nonatomic,strong)UIImageView * headImgvw2;//头像
@property (nonatomic,strong)UILabel * nameLb2;//名字
@property (nonatomic,strong)UIImageView * sxeImgvw2;//性别

-(void)FillWithModel:(VLX_mine_fensi_model *)model;


@end
