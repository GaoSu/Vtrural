//
//  NSString+UserDefault.h
//  ShiTingBang
//
//  Created by zhuhmd on 16/11/2.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UserDefault)

+ (void)setDefaultToken:(NSString *)value;

+ (NSString *)getDefaultToken;

+ (void)setDefaultUser:(NSString *)value;

+ (NSString *)getDefaultUser;

+ (void)setAlias:(NSString *)alias;

+ (NSString *)getAlias;

+ (BOOL)isNull:(NSString *)string;

- (NSString *)indexCharactor;

+ (NSString *)getBaiduMapKey;

+ (NSString *)getUMKey;

- (NSString *)getFormatTime;

+ (void )removeDefaultToken;

+ (NSString *)partner;

+ (NSString *)seller;

+ (NSString *)privateKey;

+ (NSString *)openID;

+ (NSString *)package;

//
+(NSString *)getCity;
+(NSString *)getLatitude;
+(NSString *)getLongtitude;
+(NSString *)getAreaID;

// 姓名
+ (void)setName:(NSString *)userName;

+ (NSString *)getName;

// 手机
+ (void)setPhoneNum:(NSString *)phone;

+ (NSString *)getPhone;

//地址

+ (void)setAddress:(NSString *)address;

+ (NSString *)getAddress;

// 身份证号
+ (void)setIdNum:(NSString *)idNum;

+ (NSString *)getIdNum;

//
@end
