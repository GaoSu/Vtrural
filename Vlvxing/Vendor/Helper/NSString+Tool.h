//
//  NSString+Tool.h
//  guanjia
//
//  Created by hdkj005 on 16/7/12.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

//时间转换
-(NSString *)RwnTimeExchange;
-(NSString *)RwnTimeExchange1;
-(NSString *)RwnTimeExchange2;
-(NSString *)RwnTimeExchange3;
-(NSString *)RwnTimeExchange4;
-(NSString *)RwnTimeExchange5;

//获取当前时间
+(NSString *)RwnTimeNow;
//获取当前时间戳
+(long long)RWNGetNowTimeInterval;
//计算时间间隔
+(NSString *)timeIntervalToNow:(long )date;

+ (BOOL)checkForNull:(NSString *)checkString;

//+ (BOOL)checkForNullChinese:(NSString *)checkString;

//emoji去除
- (NSString *)disable_emoji:(NSString *)text;

@end
