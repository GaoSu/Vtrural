//
//  HMAccountTool.m
//  XingJu
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#define HMAccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#define HMDynamicFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"dynamic.data"]

#define HMhxMessageFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hxMessage.data"]

#define HMVideoFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"video.data"]

#define HMUserFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

#define HMProfileFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"profile.data"]

#import "HMAccountTool.h"
#import "HMAccount.h"
#import "HMDynamic.h"
#import "HMUser.h"
#import "ZTH_User.h"

@implementation HMAccountTool

/**
 *  存储我的界面信息
 */
+ (void)saveProfile:(ZTHProfile *)profile
{
    [NSKeyedArchiver archiveRootObject:profile toFile:HMProfileFilepath];
}
/**
 *  读取我的界面信息
 */
+ (ZTHProfile *)profile
{
    ZTHProfile *profile = [NSKeyedUnarchiver unarchiveObjectWithFile:HMProfileFilepath];
    return profile;
}

/**
 *  存储帐号
 */
+ (void)saveDynamic:(HMDynamic *)dynamic
{
    // 归档
    [NSKeyedArchiver archiveRootObject:dynamic toFile:HMDynamicFilepath];
}

/**
 *  读取帐号
 */
+ (HMDynamic *)dynamic
{
    // 读取帐号
    HMDynamic *dynamic = [NSKeyedUnarchiver unarchiveObjectWithFile:HMDynamicFilepath];
    return dynamic;
}

/**
 *  存储手机号登录帐号返回的信息
// */
//+ (void)savelogUser:(ZTH_User *)logUser
//{
//    
//}
///**
// *  读取手机号登录帐号返回的信息
// */
//+ (ZTH_User *)logUser
//{
//    
//}

/**
 *  存储手机号登录帐号返回的信息
 */
+ (void)savehxMessage:(ZTHHxMessage *)hxMessage
{
    // 归档
    [NSKeyedArchiver archiveRootObject:hxMessage toFile:HMhxMessageFilepath];
}

/**
 *  读取手机号登录帐号返回的信息
 */
+ (ZTHHxMessage *)hxMessage
{
    // 读取帐号
    ZTHHxMessage *hxMessage = [NSKeyedUnarchiver unarchiveObjectWithFile:HMhxMessageFilepath];
    return hxMessage;
}

/**
 *  存储视频帐号
 */
+ (void)saveVideo:(HMVideo *)video
{
    // 归档
    [NSKeyedArchiver archiveRootObject:video toFile:HMVideoFilepath];
}
/**
 *  读取视频帐号
 */
+ (HMVideo *)video
{
    HMVideo *video = [NSKeyedUnarchiver unarchiveObjectWithFile:HMVideoFilepath];
    return video;
}



/**
 *  存储用户信息
 */
+ (void)saveUser:(HMUser *)user
{
    // 归档
    [NSKeyedArchiver archiveRootObject:user toFile:HMUserFilepath];
}

/**
 *  读取用户信息
 */
+ (HMUser *)user
{
    // 读取帐号
    HMUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:HMUserFilepath];
    return user;
}

+ (void)save:(HMAccount *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:HMAccountFilepath];
}

+ (HMAccount *)account
{
    // 读取帐号
    HMAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HMAccountFilepath];
    
    // 判断帐号是否已经过期
    NSDate *now = [NSDate date];

    if ([now compare:account.expires_time] != NSOrderedAscending) { // 过期
        account = nil;
    }
    return account;
}

+ (void)accessTokenWithParam:(HMAccessTokenParam *)param success:(void (^)(HMAccount *))success failure:(void (^)(NSError *))failure
{
    [self postWithUrl:@"https://api.weibo.com/oauth2/access_token" param:param resultClass:[HMAccount class] success:success failure:failure];
}
@end
