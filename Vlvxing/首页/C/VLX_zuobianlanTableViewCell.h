//
//  VLX_zuobianlanTableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VLX_zuobianlanModel.h"
#define kCellIdentifier_Left @"zuobianlanTableViewCell"

@interface VLX_zuobianlanTableViewCell : UITableViewCell//左边栏

@property (nonatomic, strong) UILabel * zuobianlanname;
@property (nonatomic, strong) UIImageView * zuobianlanImgVw;

//-(void)FillWithModel:(VLX_zuobianlanModel *)model;

@end
