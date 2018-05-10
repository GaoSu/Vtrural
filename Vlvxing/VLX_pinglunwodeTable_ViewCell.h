//
//  VLX_pinglunwodeTable_ViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLX_plwdModel.h"
@interface VLX_pinglunwodeTable_ViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headImgvw1;//头像
@property (nonatomic,strong)UILabel * nameLb1;//名字
@property (nonatomic,strong)UILabel * useridLb1;//userid;

-(void)FillWithModel:(VLX_plwdModel *)model;
@end
