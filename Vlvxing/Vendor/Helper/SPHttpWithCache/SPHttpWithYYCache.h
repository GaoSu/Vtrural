//
//  SPHttpWithYYCache.h
//  ShiTingBang
//
//  Created by Michael on 16/11/1.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

typedef void (^SuccessBlock)(NSDictionary * requestDic, NSString * msg);
typedef void (^FailureBlock)(NSString *errorInfo);
typedef void (^LoadProgress)(float progress);

@interface SPHttpWithYYCache : NSObject

@property (assign ,nonatomic) NSTimeInterval timeOut;
@property (assign ,nonatomic) BOOL isRichText;
@property (strong, nonatomic) NSMutableDictionary<NSString *,NSURLSessionDataTask *> *dataTaskDictionaryM;
/**
 *  Get请求 不对数据进行缓存
 *
 *  @param urlStr  url
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


+(NSURLSessionDataTask *)getRequestUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  Get请求 对数据进行缓存
 *
 *  @param urlStr  url
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


+(NSURLSessionDataTask *)getRequestCacheUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure ;



/**
 *  Post请求 不对数据进行缓存
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(NSURLSessionDataTask *)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;


/**
 *  Post请求 对数据进行缓存
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */

+(NSURLSessionDataTask *)postRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;

/**
 *  上传单个文件
 *
 *  @param urlStr       服务器地址
 *  @param parameters   参数
 *  @param attach       上传的key
 *  @param data         上传的问价
 *  @param loadProgress 上传的进度
 *  @param success      成功的回调
 *  @param failure      失败的回调
 */
+(NSURLSessionDataTask *)upLoadDataWithUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(LoadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  Post请求 对数据进行缓存带超时
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 *  @param timeOut    超时
 */
+ (NSURLSessionDataTask *)postRequestUrlStrTimeOut:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure timeOut:(NSTimeInterval)timeOut;

/**
 *  取消单个请求任务
 *
 *  @param cacheKey     请求URL
 */
+ (void)cancelTaskWihtKey:(NSString *)cacheKey;

/**
 *  取消所有任务
 *
 */
+ (void)cancelAllTask;
@end
