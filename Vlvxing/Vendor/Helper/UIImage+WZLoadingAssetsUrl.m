//
//  UIImage+WZLoadingAssetsUrl.m
//  zichanguanli
//
//  Created by handong on 17/2/10.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import "UIImage+WZLoadingAssetsUrl.h"
#import <Photos/Photos.h>

@implementation UIImage (WZLoadingAssetsUrl)
+ (UIImage *)imageWithAssetsUrl:(NSURL *)url{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
    __block UIImage *image = nil;
    for (PHAsset *asset in assets) {
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            image = result;
        }];
    }
    return image;
}
@end
