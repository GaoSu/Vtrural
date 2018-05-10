//
//  VLX_buyTicketViewController.h
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^payTypeBlock)(NSInteger tag);//跟下边相关

@interface VLX_buyTicketViewController : BaseViewController



@property (nonatomic,strong)NSString * navStr11;//航空公司名称及航班
@property (nonatomic,strong)NSString * NavStr22;///
@property (nonatomic,strong)NSString * jiageStr_0;//价格
@property (nonatomic,strong)NSString * timeStr;//date起飞年月日期,需要转汉子为-
@property (nonatomic,strong)NSString * xingqiStr;//星期几

@property (nonatomic,strong)NSString * vendorStr;//有报价接口传过来的参数（需要用URLEncoder.encode转码）
@property (nonatomic,strong)NSString * depCode;//出发城市三字码
@property (nonatomic,strong)NSString * arrCode;//落地城市三字码
@property (nonatomic,strong)NSString * code;//航班号
@property (nonatomic,strong)NSString * carrier;//航司
@property (nonatomic,strong)NSString * btime;//起飞具体时间
@property (nonatomic,strong)NSString * bookingResult;//预定结果,生单用

@property (nonatomic,copy)payTypeBlock payTypeBlock;

@property (nonatomic,strong)NSString * jijianranyoustr;//基建燃油



@end
