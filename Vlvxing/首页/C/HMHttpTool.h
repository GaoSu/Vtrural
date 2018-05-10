//
//  HMHttpTool.m
//  XingJu
// 
//  Created by apple on 14-7-11.
//All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义了一个叫做successBlock的类型 它没有返回值, 也不接收任何参数]
typedef void (^successBlock)(id  responseObject);
//typedef void (^failureBlock)(NSError *error);
//typedef void (^ProgressBlock)(id responseObject,NSProgress *uploadProgress);

@interface HMHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

//+ (void)tangyangPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+ (void)postMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(successBlock)succeedBlock
                           failedBlock:(failureBlock)failedBlock
                   uploadProgressBlock:(ProgressBlock)uploadProgressBlock;

@end
