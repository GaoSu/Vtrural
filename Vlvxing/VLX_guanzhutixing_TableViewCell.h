//
//  VLX_guanzhutixing_TableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_plwdModel.h"
@interface VLX_guanzhutixing_TableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * HeadimgVw;//头像
@property (nonatomic,strong)UILabel * nameLB;//名字
@property (nonatomic,strong)UILabel * timeLb;//年月日
@property (nonatomic,strong)UILabel * tishiLb;//提示文字

-(void)FillWithModel:(VLX_plwdModel *)model;
@end
