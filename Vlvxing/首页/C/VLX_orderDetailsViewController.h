//
//  VLX_orderDetailsViewController.h
//  Vlvxing
//
//  Created by grm on 2017/10/16.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLX_orderDetailsViewController : BaseViewController


@property (nonatomic ,strong)UIImage * headImgStr;//图标
@property (nonatomic ,strong)NSString * NAMEStr;//航空公司大名
@property (nonatomic ,strong)NSString * datesStr;//日期
@property (nonatomic ,strong)NSString * starsStr;//周几

@property (nonatomic ,strong)NSString * flyDatesStr;//日期
@property (nonatomic ,strong)NSString * flyAreaStr;//起飞机场
@property (nonatomic ,strong)NSString * flyTimeStr;//起飞时间
@property (nonatomic ,strong)NSString * downAreaStr;//降落机场

@property (nonatomic ,strong)NSString * downTimeStr;//降落时间
@property (nonatomic ,strong)NSString * hangbanNoStr;//航班号
@property (nonatomic ,strong)NSString * classStr;//座舱级别(经济舱)
@property (nonatomic ,strong)NSString * typeStr;//成人票

@property (nonatomic ,strong)NSString * jiageStr;//价格

@property  (nonatomic,strong)NSString * ID_cardNoStr;//身份信息


@end
