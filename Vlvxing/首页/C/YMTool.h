//
//  YMTool.h
//  AiMoo
//
//  Created by Apple on 15/8/22.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

/**
 *  各种工具类
 */

@interface YMTool : NSObject

// 定义了一个叫做successBlock的类型 它没有返回值, 也不接收任何参数]
typedef void (^successBlock)(id  responseObject);
//typedef void (^failureBlock)(NSError *error);

//typedef void (^ProgressBlock)(id  responseObject);


//获取主appdelegate
+ (AppDelegate*)MyAppdelegate;

/**字符串判空*/
+(Boolean)isKongString:(NSString *) parmStr;

/**手机号合法判断*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**邮箱合法*/
+ (BOOL)isEmail:(NSString*)email;

/**检测网络状态*/
+(BOOL)netWorkConnectState;

/**
 *  验证身份证号码
 */
+(BOOL)isIdentityCardNo:(NSString*)cardNo;

/**
 *  返回宽度
 */
+(CGFloat)getWidth:(NSString *)string font:(UIFont *)font;

/**
 *  返回高度
 */
+(CGFloat)getHeight:(NSString *)string font:(UIFont *)font;

/**
 *  四舍五入,处理数据(number:需要处理的数字， position：保留小数点第几位，)
 */
+(NSString *)roundUp:(float)number afterPoint:(int)position;

/**
 *  密码只能是6到20位的数字和字母组成，正则表达式
 */
+(BOOL)isValidatePassword:(NSString *)passStr;

//弹窗相关==============================================================
/**显示黑色等待弹窗*/
+ (MBProgressHUD*)openHUD:(NSString*)message view:(UIView*)myview;
+ (void)closeHUD:(MBProgressHUD*)HUD;
/**显示黑色定时弹窗*/
+ (void)openIntervalHUD:(NSString*)message view:(UIView*)myview;
/**显示黑色定时弹窗(带对勾的表示发表成功之类的)*/
+ (void)openIntervalHUDOK:(NSString*)message view:(UIView*)myview;


/**
 *  发送get请求
 *
 *  @param url        请求的地址
 *  @param parameters 求情参数
 *  @param success    请求成功的回调
 *  @param failure    求情失败的回调
 */
+ (void)getWithURl:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;

/**
 *  发送post请求
 *
 *  @param url        请求的地址
 *  @param parameters 求情参数
 *  @param success    请求成功的回调
 *  @param failure    求情失败的回调
 */
+ (void)postWithURl:(NSString *)url parameters:(NSDictionary *)parameters  success:(successBlock)success failure:(failureBlock)failure;


/**
 *  用颜色做按钮的背景图片
 *
 *  @param color 按钮颜色
 *
 *  @return 按钮背景图片
 */
+ (UIImage *)BtnBackGroundImageWithColor:(UIColor *)color;

//获取随机数 从from 到to
+(int)getRandomNumber:(int)from to:(int)to;

//
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

//json转dic
+ (NSDictionary *)jsonStringToNSDictionary:(NSString *)jsonString;

//dic转json
+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic;

//存本地
+ (void)saveStr:(NSString *)str forKey:(NSString *)key;
//取本地
+ (NSString *)getStrUseKey:(NSString *)key;

//画虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
比较两个时间,晚的时间在前
 */
+(NSTimeInterval)compareTimeWithTime1:(NSString *)time1 time2:(NSString *)time2;

/**
    将视频写入本地
 */
+(NSString *)writeToFileVideo:(NSData *)data;
@end
