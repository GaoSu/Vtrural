//
//  HMHttpTool.m
//  XingJu
//
//  Created by apple on 14-7-11.
//All rights reserved.
//

#import "HMHttpTool.h"
#import "AFNetworking.h"

@implementation HMHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil]];
    
//    NSString * stokenstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    [mgr.requestSerializer setValue:stokenstr forHTTPHeaderField:@"token"];//将token拼接到头里边

    
    
    // 2.发送GET请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil]];
    
//    NSString * stokenstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSLog(@"HMHttpTool中post设备的token是 %@",stokenstr);
//    [mgr.requestSerializer setValue:stokenstr forHTTPHeaderField:@"token"];//将token拼接到头里边
    
    
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数(//name:传的是请求参数)
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+(void)postMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(successBlock)succeedBlock
                           failedBlock:(failureBlock)failedBlock
                   uploadProgressBlock:(ProgressBlock)uploadProgressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString * stokenstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSLog(@"post设备的token是 %@",stokenstr);
//    [manager.requestSerializer setValue:stokenstr forHTTPHeaderField:@"token"];
    
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];

    //设置类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            
            //name:传的是请求参数
            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/png"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        if (uploadProgressBlock) {
//            uploadProgressBlock(uploadProgress,uploadProgress);
//        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeedBlock) {
            succeedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
    }];
    
}


-(NSURLSessionDataTask *)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters   isCache:(BOOL)isCache  cacheKey:(NSString *)cacheKey imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(LoadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    NSURLSessionDataTask *task = nil;
    
    //处理中文和空格问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //拼接
    NSString * cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
    MyLog(@"网络地址%@",cacheUrl);

    return nil;
}

-(void)requestWithUrl:(NSString *)url withDic:(NSDictionary *)paras{
    //处理中文和空格问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //拼接
    NSString * cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:paras];
    MyLog(@"grm网络地址%@",cacheUrl);
}


-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        [parts addObject:part];
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"%@",queryString] : @"";
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    return pathStr;

}




@end
