//
//  UploadImageTool.h
//  HeXie
//
//  Created by handong on 16/8/1.
//  Copyright © 2016年 HDKJ iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UrlBlock)(NSString *url);
typedef void (^failedBlock)(NSString *error);
typedef void (^loadProgress)(float progress);

typedef void (^UrlArrayBlock)(NSArray *urlArray, int count);
typedef void (^ImagesFailedBlock)(NSString *error, int count);
typedef void (^ProgressBlock)(int count);

@interface UploadImageTool : NSObject
/**
 *  初始化
 *
 */
+ (instancetype)instance;
/**
 *  上传单张图片
 *
 *  @param img   图片
 */
+ (void)UploadImage:(UIImage *)img upLoadProgress:(loadProgress)loadProgress successUrlBlock:(UrlBlock)url failBlock:(failedBlock)failure;


/**
 *  上传多张图片
 *
 *  @param imgArr   图片
 */
- (void)UploadImageArray:(NSArray *)imgArr upLoadProgress:(loadProgress)loadProgress successUrlArrayBlock:(UrlArrayBlock)urlArr failBlock:(ImagesFailedBlock)failure progress:(ProgressBlock)progressCount;
@end
