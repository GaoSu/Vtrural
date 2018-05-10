//
//  VLX_gaiqianChooseVC.h
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"//选择需要改签的订单

@interface VLX_gaiqianChooseVC : BaseViewController

@property (nonatomic,strong)NSString * orderno;
@property (nonatomic,strong)NSString * flyDatesStr2;//起飞日期

@property (nonatomic,strong) NSString *locationStr2;//当前时间
@property (nonatomic,strong )NSString * xingqijiStr;//星期几


@property (nonatomic,strong)NSString * nav_title1;//起飞地

@property (nonatomic,strong) NSString *nav_title2;//目的地

@property (nonatomic,strong) NSMutableArray * passengeridArray;//用于下下个界面用户id
//@property (nonatomic,strong) NSString * jiadePassengerid;//假的id

@end
