//
//  VLX_myOrderTableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLX_myOrderModel.h"

@interface VLX_myOrderTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * typelb;//订单状态
@property (nonatomic,strong)UILabel * typelbNO;//订单状态编号
@property (nonatomic, strong)UILabel * area1Lb;//出发地
@property (nonatomic,strong)UILabel * area2Lb;//目的地
@property (nonatomic,strong)UILabel * jiageLb;//价格
@property (nonatomic,strong)UILabel * hangbanNoLb;//航班号
@property (nonatomic,strong)UILabel * timeLb;//日期时间
@property (nonatomic,strong)UILabel * flyLb;//起飞时间
@property (nonatomic,strong)UILabel * downLb;//降落时间
@property (nonatomic,strong)UILabel * zongshichangLb;//总时长
@property (nonatomic,strong)UILabel * orderidLb;//订单id
@property (nonatomic,strong)UILabel * ordernoLb;//订单号




@property (nonatomic,strong)UILabel * arriairportcity;//降落机场
@property (nonatomic,strong)UILabel * deptairportcity;//起飞机场

-(void)FillWithModel:(VLX_myOrderModel *)model;


@end
