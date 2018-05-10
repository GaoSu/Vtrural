//
//  VLX_gaiqianDoneViewController.h
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"//改签确认,就要支付改签费了

@interface VLX_gaiqianDoneViewController : BaseViewController

//@property(nonatomic,strong)NSString * xxx;//未知参数,
//一堆未知参数
@property (nonatomic,strong)NSString * name1;//航空公司名称及航班
@property (nonatomic,strong)NSString * date2;//日期
@property (nonatomic,strong)NSString * xingqijiStr;//星期几
@property (nonatomic,strong)NSString * sta3;//开始时间
@property (nonatomic,strong)NSString * over4;//结束时间
@property (nonatomic,strong)NSString * total5;//总耗时
@property (nonatomic,strong)NSString * orderNo;//订单号
@property (nonatomic,strong)NSString * order_ID;//订单id

@property (nonatomic,strong)NSString * fly7;//起飞机场
@property (nonatomic,strong)NSString * down8;//降落机场
@property (nonatomic,strong)NSString * servers9;//服务质量及内容
@property (nonatomic,strong)NSString * change11;//退改费用
@property (nonatomic,strong)NSString * zhekou12;//折扣率
//@property (nonatomic,strong)UIButton * bookingBt;//预定按钮
@property (nonatomic,strong)NSString * hangbanhaoStr;//航班号
@property (nonatomic,strong)NSString * cabinCodeStr;//改签用,

@property (nonatomic,strong)NSString * gqfee;//改签费
@property (nonatomic,strong)NSString * upgradeFee;//升舱费
@property (nonatomic,strong)NSString * allfee;//总价
@property (nonatomic,strong)NSString * uniqKey;//uniqKeyLb


@property (nonatomic,strong)NSMutableArray * chengkeArray;//乘客数组

//@property (nonatomic,strong) NSString * jiadePassengerid;//假的id
@property (nonatomic,strong)NSMutableArray * passengeridArray;

@end
