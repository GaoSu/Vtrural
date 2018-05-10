//
//  VLX_tuipiaoViewController.h
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"//退票页

@interface VLX_tuipiaoViewController : BaseViewController

@property (nonatomic ,strong)NSString * NAMEStr1;//航空公司大名
@property (nonatomic ,strong)NSString * starsStr1;//周几

@property (nonatomic ,strong)NSString * flyDatesStr1;//起飞日期
@property (nonatomic ,strong)NSString * xingqijiStr1;//是星期几
@property (nonatomic ,strong)NSString * flyPortStr1;//起飞机场
@property (nonatomic ,strong)NSString * flyCityStr1;//起飞城市

@property (nonatomic ,strong)NSString * flyTimeStr1;//起飞时间
@property (nonatomic ,strong)NSString * downportStr1;//降落机场
@property (nonatomic ,strong)NSString * downCityStr1;//降落城市
@property (nonatomic ,strong)NSString * zongshichang1;//总时长
@property (nonatomic ,strong)NSString * downTimeStr1;//降落时间
@property (nonatomic ,strong)NSString * hangbanNoStr1;//航班号
//@property (nonatomic ,strong)NSString * typeStr1;//成人票

@property (nonatomic ,strong)NSString * jiageStr1;//价格


@property  (nonatomic,strong)NSString * Name_Str1;//姓名

@property  (nonatomic,strong)NSString * ID_cardNoStr1;//身份证号

@property (nonatomic,strong)NSString * Phone_NoStr1;//手机号


@property (nonatomic ,strong)NSString * orderid1;//订单id
@property (nonatomic ,strong)NSString * orderno1;//订单号
@property (nonatomic ,strong)NSString * statusdescStr1;//订单状态

@property (nonatomic ,strong)NSMutableArray*chengkexinxiAry1;//乘客人数,

@property(nonatomic,strong)NSString * jiadePassengerid;//假的id
@property (nonatomic,strong)NSMutableArray * passengeridArray;

@end
