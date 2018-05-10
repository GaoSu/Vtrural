//
//  VLX_SearchModel.h
//  Vlvxing
//
//  Created by grm on 2017/10/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_SearchModel : NSObject

@property (nonatomic,strong)NSString * arr;//降落机场返回码
@property (nonatomic,strong)NSString * arrAirport;//降落机场
@property (nonatomic,strong)NSString * arrTime;//降落时间flightTimes
@property (nonatomic,assign)double barePrice;//价格

@property (nonatomic,strong)NSString * dpt;//起飞机场返回码
@property (nonatomic,strong)NSString * dptAirport;//起飞机场
@property (nonatomic,strong)NSString * dptTime;//起飞时间
@property (nonatomic,strong)NSString * flightNum;//航空公司的航班
@property (nonatomic,strong)NSString * airlineName;//航空公司的名字
@property (nonatomic,strong)NSString * carrier;//航空公司的名字二字码
@property (nonatomic,strong)NSString * flightTimes;//总时长
@property (nonatomic,strong)NSString * flightTypeFullName;//飞机型号名字
@property (nonatomic,assign)BOOL stop;//是否经停,true表示经停,false表示无经停

@property (nonatomic,assign)int tof;//燃油
@property (nonatomic,assign)int arf;//基建
//@property (nonatomic,assign)long  createTime;//时间戳
//@property (nonatomic,strong)NSDictionary  * result;//报价类型
//@property (nonatomic,strong)NSNumber * flyTime;
//@property (nonatomic,strong)NSNumber * downTime;
//@property (nonatomic,strong)NSString * totalTime;
//@property (nonatomic,strong)NSString * jiage;
//@property (nonatomic,strong)NSString * area1;
//@property (nonatomic,strong)NSString * area2;
//
//@property (nonatomic,strong)NSString * imgUrl;
//@property (nonatomic,strong)NSNumber * companyName;//航空公司名字
//@property (nonatomic,strong)NSNumber * planeName;//飞机名字

+(VLX_SearchModel *)infoListWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;



@end
//property has a aprevious declaration
