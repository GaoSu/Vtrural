//
//  VLXCustomTripModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/31.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLXCustomTripModel : NSObject
@property (nonatomic,copy)NSString *startCity;//出发城市
@property (nonatomic,copy)NSString *endCity;//目的地
@property (nonatomic,copy)NSString *endCityId;//目的地id
@property (nonatomic,copy)NSString *date;//出发日期
@property (nonatomic,copy)NSString *days;//出行天数
@property (nonatomic,copy)NSString * peoples;//出行人数
@property (nonatomic,copy)NSString *name;//姓名
@property (nonatomic,copy)NSString *phone;//电话
@property (nonatomic,copy)NSString *email;//邮箱
@property (nonatomic,copy)NSString *others;//行程需求
-(BOOL)checkIsFull;
@end
