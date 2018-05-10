//
//  UploadImageTool.m
//  HeXie
//
//  Created by handong on 16/8/1.
//  Copyright © 2016年 HDKJ iOS. All rights reserved.
//

#import "UploadImageTool.h"
#import "ZhuHTTPSessionManager.h"



@interface UploadImageTool ()
@property (strong, nonatomic) NSMutableArray *urlArrM;
@property (assign, nonatomic) int upImageCount;
@end

@implementation UploadImageTool
- (instancetype)init{
    if (self = [super init]) {
        self.upImageCount = 0;
    }
    return self;
}
+ (instancetype)instance{
    return [[[self class] alloc] init];
}
/*  上传单张图片
 *  @ img   图片
 *  @ url
 *  @ error
 */
+ (void)UploadImage:(UIImage *)img upLoadProgress:(loadProgress)loadProgress successUrlBlock:(UrlBlock)url failBlock:(failedBlock)failure{

    NSData *imgData = UIImageJPEGRepresentation(img, 0.35);;
    NSString *urlStr = [NSString stringWithFormat:@"%@/tool/uploadAPI.json",ftpPath];
    //处理中文和空格问题
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *session = [ZhuHTTPSessionManager shareManager];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    session.requestSerializer.timeoutInterval =  60;
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session POST:urlStr parameters:@{@"filemark":@1} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
        NSString * fileName = [NSString stringWithFormat:@"%.0f.jpg",timeInterVal];
        [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary* dic  = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableLeaves error:nil];

        NSLog(@"图片上传返回OK:%@",dic);
        if ([[dic objectForKey:@"status"] intValue] == 1)
        {
            
            if (![[dic objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
                NSString *imageStr = [dic objectForKey:@"data"];
                url(imageStr);
            }
        }else{
            NSString *message = [dic objectForKey:@"message"];
            failure(message);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"您的网络可能有问题");
    }];
}


/**
 *  上传多张图片
 *
 *  @ imgArr   图片
 *  @ urlArr
 *  @ error
 *  @ upCount
 */
- (void)UploadImageArray:(NSArray *)imgArr upLoadProgress:(loadProgress)loadProgress successUrlArrayBlock:(UrlArrayBlock)urlArr failBlock:(ImagesFailedBlock)failure progress:(ProgressBlock)progressCount {

    UIImage *img = imgArr[self.upImageCount];
    NSLog(@"self.upImageCount:%d",self.upImageCount);//0,1,2递增
    NSLog(@"imgArr[self.upImageCount]:%@",imgArr[self.upImageCount]);
    [[self class] UploadImage:img upLoadProgress:^(float progress) {//走单张图片接口
        
        loadProgress(progress);
        
    } successUrlBlock:^(NSString *url) {

        NSLog(@"url::::%@",url);
        [self.urlArrM addObject:url];
        self.upImageCount++;
        progressCount(self.upImageCount);
        NSLog(@"progressCount:%@",progressCount);
        if (self.upImageCount == imgArr.count) {
            NSArray *urls = [NSArray arrayWithArray:self.urlArrM];
            urlArr(urls,_upImageCount);
            NSLog(@"urlArr:%@",urlArr);
        }else{
            [self UploadImageArray:imgArr upLoadProgress:loadProgress successUrlArrayBlock:urlArr failBlock:failure progress:progressCount];
            NSLog(@"mmmmmmmmmmmm");
        }
        
    } failBlock:^(NSString *error) {
        failure(error,_upImageCount);
    } ];
}

- (NSMutableArray *)urlArrM{
    if (!_urlArrM) {
        _urlArrM = [NSMutableArray array];
    }
    return _urlArrM;
}
@end
