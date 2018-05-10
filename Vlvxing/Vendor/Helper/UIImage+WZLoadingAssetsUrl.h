//
//  UIImage+WZLoadingAssetsUrl.h
//  zichanguanli
//
//  Created by handong on 17/2/10.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WZLoadingAssetsUrl)
//url (assets-library://asset/asset.JPG?id=1000000194&ext=JPG)
+ (UIImage *)imageWithAssetsUrl:(NSURL *)url;
@end
