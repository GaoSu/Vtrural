//
//  VLX_guoqibookingVC.h
//  Vlvxing
//
//  Created by grm on 2017/11/28.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLX_guoqibookingVC : BaseViewController

@property (nonatomic,strong)NSString *jiageStr;
@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic ,strong)NSString * statusdescStr;//已支付或未支付
@property (nonatomic ,strong)NSString * typeStr;//成人票

@property  (nonatomic,strong)NSString * Name_Str;//姓名

@property  (nonatomic,strong)NSString * ID_cardNoStr;//身份证号

@property (nonatomic,strong)NSString * Phone_NoStr;//手机号

@property (nonatomic,strong)NSMutableArray * chengkexinxiAry;//乘客信息

@property (nonatomic,strong)NSString * xingqijiStr;//星期

@property (nonatomic ,strong)NSString * NAMEStr;//航空公司大名
@property (nonatomic ,strong)NSString * starsStr;//周几

@property (nonatomic ,strong)NSString * flyDatesStr;//起飞日期
@property (nonatomic ,strong)NSString * flyPortStr;//起飞机场
@property (nonatomic ,strong)NSString * flyCityStr;//起飞城市

@property (nonatomic ,strong)NSString * flyTimeStr;//起飞时间
@property (nonatomic ,strong)NSString * downportStr;//降落机场
@property (nonatomic ,strong)NSString * downCityStr;//降落城市
@property (nonatomic ,strong)NSString * zongshichang;//总时长
@property (nonatomic ,strong)NSString * downTimeStr;//降落时间
@property (nonatomic ,strong)NSString * hangbanNoStr;//航班号
@property (nonatomic ,strong)NSString * classStr;//座舱级别(经济舱)

@end
