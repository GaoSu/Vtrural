//
//  VLX_gaiqianViewController.h
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"////改签

@interface VLX_gaiqianViewController : BaseViewController

@property (nonatomic ,strong)NSString * flyCityStr;//起飞地点,不展示,用于传值

@property (nonatomic ,strong)NSString * downCityStr;//目的地修改

@property (nonatomic ,strong)NSString * flyDatesStr;//起飞日期修改

@property (nonatomic ,strong)NSString * orderno;//订单号
@property (nonatomic ,strong)NSString * xingqijiStr;//星期几
//@property (nonatomic ,strong)NSString * orderid;//订单id
//@property (nonatomic ,strong)NSString * hangkonggongsi;//航空公司
@property (nonatomic,strong) NSMutableArray * passengeridArray;//用于下下下个界面用户id
@property (nonatomic,strong) NSString * jiadePassengerid;//假的id



@end
