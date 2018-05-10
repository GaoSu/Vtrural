//
//  ZYYOSSUploader.h
//  BaseProject
//
//  Created by 王静雨 on 2017/5/16.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
typedef void(^uploaderBlock)(BOOL isSuccess);

//新增
typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface ZYYOSSUploader : NSObject
+ (instancetype)sharedInstance;

//新增
+ (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;

- (void)setupEnvironment;// 初始化各种设置
- (void)uploadObjectAsyncWithFileUrl:(NSString *)filePath  andFileName:(NSString *)fileName;
@property (nonatomic,copy)uploaderBlock uploaderBlock;
@end
