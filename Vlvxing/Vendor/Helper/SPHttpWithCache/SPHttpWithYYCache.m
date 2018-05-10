//
//  SPHttpWithYYCache.m
//  ShiTingBang
//
//  Created by Michael on 16/11/1.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "SPHttpWithYYCache.h"
#import "ZhuHTTPSessionManager.h"
#import "AFNetworking.h"
#import "VLXLoginVC.h"
//#import "LoginController.h"
//#import "TokenAlert.h"


//YYCache
NSString * const SPHttpCache = @"SPHttpCache";

// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
};

@implementation SPHttpWithYYCache

+(NSURLSessionDataTask *)getRequestUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[SPHttpWithYYCache shareInstance] requestWithUrl:urlStr withDic:nil requestType:RequestTypeGet isCache:NO cacheKey:nil imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}




+(NSURLSessionDataTask *)getRequestCacheUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    return [[SPHttpWithYYCache shareInstance] requestWithUrl:urlStr withDic:nil requestType:RequestTypeGet isCache:YES cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+ (NSURLSessionDataTask *)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[SPHttpWithYYCache shareInstance] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:NO cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+(NSURLSessionDataTask *)postRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[SPHttpWithYYCache shareInstance] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:YES cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+(NSURLSessionDataTask *)upLoadDataWithUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[SPHttpWithYYCache shareInstance] requestWithUrl:urlStr withDic:parameters requestType:RequestTypeUpLoad isCache:NO cacheKey:urlStr imageKey:attach withData:data upLoadProgress:^(float progress) {
        loadProgress(progress);
    } success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+ (NSURLSessionDataTask *)postRequestUrlStrTimeOut:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure timeOut:(NSTimeInterval)timeOut
{
    SPHttpWithYYCache *sphttp = [self alloc];
    sphttp.timeOut = timeOut;
    
    return [sphttp requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:YES cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
#pragma mark -- 网络请求统一处理
-(NSURLSessionDataTask *)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters requestType:(RequestType)requestType  isCache:(BOOL)isCache  cacheKey:(NSString *)cacheKey imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(LoadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSURLSessionDataTask *task = nil;
    
    //处理中文和空格问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //拼接
    NSString * cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
    MyLog(@"网络地址%@",cacheUrl);
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:SPHttpCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;

    id cacheData;
    if (isCache) {
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheKey];
        if (cacheData != 0) {
            //将数据统一处理
            [self returnDataWithRequestData:cacheData Success:^(NSDictionary *requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        }
    }
    
    //进行网络检查
    if (![self requestBeforeJudgeConnect]) {
        failure(@"您的网络可能有问题");
        return task;
    }

    ZhuHTTPSessionManager *session = [ZhuHTTPSessionManager shareManager];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    
//    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
//    session.securityPolicy = securityPolicy;
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];

    if (self.timeOut != 0) {
        session.requestSerializer.timeoutInterval = self.timeOut;
    }else {
        session.requestSerializer.timeoutInterval = 20;
    }
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //GET请求
    if (requestType == RequestTypeGet) {
        task = [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self removeTaskWithKey:cacheKey];
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheKey success:^(NSDictionary *requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self removeTaskWithKey:cacheKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
            });
            if (error.code == -999) {
                failure(nil);
            }else{
                failure(@"您的网络可能有问题");
            }
        }];
    }
    
    //POST请求
    if (requestType == RequestTypePost) {
        task = [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self removeTaskWithKey:cacheKey];
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheKey success:^(NSDictionary *requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self removeTaskWithKey:cacheKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
            });
            if (error.code == -999) {
                failure(nil);
            }else{
                failure(@"您的网络可能有问题");
            }
            
        }];
    }
    
    //UpLoad上传
    if (requestType == RequestTypeUpLoad) {
        task = [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [NSString stringWithFormat:@"%@.png",@(timeInterVal)];
            [formData appendPartWithFileData:data name:attach fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            loadProgress((float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self removeTaskWithKey:cacheKey];
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cache:nil cacheKey:nil success:^(NSDictionary *requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self removeTaskWithKey:cacheKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
            });
            if (error.code == -999) {
                failure(nil);
            }else{
                failure(@"您的网络可能有问题");
            }
        }];
    }
    if (task && ![self.dataTaskDictionaryM objectForKey:cacheKey]) {
        [self.dataTaskDictionaryM setObject:task forKey:cacheKey];
    }
    return task;
}

#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cache:(YYCache*)cache cacheKey:(NSString *)cacheKey success:(SuccessBlock)success failure :(FailureBlock)failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
    });
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (self.isRichText) {
        dataString = [self deleteSpecialCodeWithStr:dataString];
    }
    
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    id requestRequst = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:nil];
    if ([requestRequst isKindOfClass:[NSDictionary class]]) {
        NSDictionary *requestDict = (NSDictionary *)requestRequst;
        int status = [requestDict[@"status"] intValue];
        if (isCache && status == 1) {
            [cache setObject:requestData forKey:cacheKey];
        }
    }

    //如果不缓存 或者 数据不相同 从网络请求
    if (!isCache || ![cacheData isEqual:requestData]) {
        [self returnDataWithRequestData:requestData Success:^(NSDictionary *requestDic, NSString *msg) {
            success(requestDic,msg);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
    }

}

/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
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

#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];

    //判断是否为字典
    if ([myResult isKindOfClass:[NSDictionary  class]]) {
        NSDictionary *  requestDic = (NSDictionary *)myResult;

        if (requestDic[@"status"] && [requestDic[@"status"] intValue] == 602) {
            [self turnToLogin1];
            return;
        }
        if (requestDic[@"status"] && [requestDic[@"status"] intValue] == 609) {
            [SVProgressHUD showErrorWithStatus:@"您的账号已被封"];
            [self turnToLogin1];
            return;
        }
        if (requestDic[@"status"] && [requestDic[@"status"] intValue] == 403) {
            [self turnToLogin1];
            return;
        }
        success(requestDic,requestDic[@"message"]);
    }
}

- (void)turnToLogin1
{
  
    UINavigationController *nav = self.cyl_tabBarController.selectedViewController;
    NSArray *array = nav.viewControllers;
    BOOL isshow=YES;
    
    
    for (UIViewController *controlller in array) {
        if ([controlller isKindOfClass:[VLXLoginVC class]]) {
            isshow=NO;
        }
    }
    UIViewController *currentVC=array.lastObject;
    if (isshow) {
        UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"您的账号在另外一台手机登录。如非本人操作，则密码可能泄漏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            MyLog(@"取消");
            [NSString hd_removeDefaultUserID];
            [NSString removeDefaultToken];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sameLogin" object:nil userInfo:@{@"loginout":@"1"}];
            
        }];
        UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [NSString removeDefaultToken];
            VLXLoginVC * login=[[VLXLoginVC alloc]init];
            
            [currentVC presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
            MyLog(@"确定退出");
        }];
        [alertControl addAction:cancleAction];
        [alertControl addAction:sureAction];
        [currentVC presentViewController:alertControl animated:YES completion:^{
            
            
        }];
    }
    /*
    for (UIViewController *controlller in array) {
        if ([controlller isKindOfClass:[LoginController class]]) {
            isshow=NO;
        }
    }
    
    if (isshow) {
        [[TokenAlert sharedTokenManager] showAlert];
    }
    */
    
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

#pragma mark  网络判断
- (BOOL) requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}

#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<td>" withString:@""];
    return string;
}
#pragma mark  WZdateTaskCancel
- (void)removeTaskWithKey:(NSString *)cacheKey{
    [self.dataTaskDictionaryM removeObjectForKey:cacheKey];
}
//取消一个任务
+ (void)cancelTaskWihtKey:(NSString *)cacheKey{
    SPHttpWithYYCache *spHttp = [SPHttpWithYYCache shareInstance];
    NSURLSessionDataTask *dataTask = [spHttp.dataTaskDictionaryM objectForKey:cacheKey];
    if (dataTask) {
        [dataTask cancel];
    }
}
//取消所有任务
+ (void)cancelAllTask{
    SPHttpWithYYCache *spHttp = [SPHttpWithYYCache shareInstance];
    for (NSURLSessionDataTask *dataTask in [spHttp.dataTaskDictionaryM allValues]) {
        [dataTask cancel];
    }
}
#pragma mark  WZ单例
static SPHttpWithYYCache* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        
    }) ;
    return _instance ;
}

-(instancetype)init{

    if (self=[super init]) {
       _dataTaskDictionaryM = [NSMutableDictionary dictionary]; 
    }
    return self;
}



+(id) allocWithZone:(struct _NSZone *)zone
{
    return [SPHttpWithYYCache shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [SPHttpWithYYCache shareInstance] ;
}
@end
