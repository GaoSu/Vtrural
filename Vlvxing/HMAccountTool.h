//
//  HMAccountTool.h
//  XingJu
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAccessTokenParam.h"

#import "HMBaseTool.h"
@class HMDynamic,HMAccount,HMUser,ZTHProfile,HMVideo,ZTHHxMessage;

@interface HMAccountTool : HMBaseTool

/**
 *  存储我的界面信息
 */
+ (void)saveProfile:(ZTHProfile *)profile;
/**
 *  读取我的界面信息
 */
+ (ZTHProfile *)profile;

/**
 *  存储帐号
 */
+ (void)saveDynamic:(HMDynamic *)dynamic;
/**
 *  读取帐号
 */
+ (HMDynamic *)dynamic;

/**
 *  存储手机号登录帐号返回的信息
 */
+ (void)savehxMessage:(ZTHHxMessage *)hxMessage;
/**
 *  读取手机号登录帐号返回的信息
 */
+ (ZTHHxMessage *)hxMessage;

/**
 *  存储视频帐号
 */
+ (void)saveVideo:(HMVideo *)video;
/**
 *  读取视频帐号
 */
+ (HMVideo *)video;


/**
 *  存储用户信息
 */
+ (void)saveUser:(HMUser *)user;

/**
 *  读取用户信息
 */
+ (HMUser *)user;


/**
 *  存储帐号
 */
+ (void)save:(HMAccount *)account;
/**
 *  读取帐号
 */
+ (HMAccount *)account;

/**
 *  获得accesToken
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)accessTokenWithParam:(HMAccessTokenParam *)param success:(void (^)(HMAccount *account))success failure:(void (^)(NSError *error))failure;

@end
