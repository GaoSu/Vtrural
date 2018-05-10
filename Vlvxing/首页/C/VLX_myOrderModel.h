//
//  VLX_myOrderModel.h
//  Vlvxing
//
//  Created by grm on 2017/10/17.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_myOrderModel : NSObject



@property (nonatomic,strong)NSString *statusdesc;//订单状态,中文
@property (nonatomic,assign)int  status;//订单状态码,
@property(nonatomic,assign)long userid;
@property (nonatomic,copy)NSString * deptcity;//出发地
@property (nonatomic,copy)NSString * arricity;//目的地
@property (nonatomic,copy)NSString * airlinename;//航空公司
@property (nonatomic,copy)NSString * airlinecode;//航空公司


@property (nonatomic,copy)NSString *flightnum;//航班编号
@property (nonatomic,copy)NSString *deptdate;//起飞日期
@property (nonatomic,copy)NSString *depttime;//起飞具体时间
@property (nonatomic,copy)NSString *arritime;//luodi具体时间
@property (nonatomic,copy)NSString *flighttimes;//飞行时长
@property (nonatomic,copy)NSString *cabin;//仓位

@property (nonatomic,assign)int  orderstate;//假山处状态,传1,代表删除
@property (nonatomic,strong)NSString * clientsite;//代理商域名.后期要用

@property (nonatomic,copy)NSString * orderid;//订单id///
@property (nonatomic,copy)NSString * orderno;//订单号
@property (nonatomic,copy)NSString * phone;//手机号码

@property (nonatomic,copy)NSString * deptairportcity;//起飞机场
@property (nonatomic,copy)NSString * arriairportcity;//降落机场

@property (nonatomic,assign)int nopayamount;//待支付票价
@property (nonatomic,assign)NSString * allowchange;//是否可以签传ture允许签传,
@property (nonatomic,assign)NSString * cancharge;//是否允许改签ture允许
@property (nonatomic,assign)NSString * canrefund;//是否允许退票 ture允许



@property (nonatomic,strong) NSMutableArray * passengers;//乘客信息


@property(nonatomic,strong) VLX_myOrderModel * myOrderModel;


+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
