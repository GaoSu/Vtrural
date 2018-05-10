//
//  HMStatusPhotosView.h
//  XingJu
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 heima. All rights reserved.
//  微博cell里面的相册 -- 里面包含N个HMStatusPhotoView

#import <UIKit/UIKit.h>
@class HMDynamic;

@interface HMStatusPhotosView : UIView
/**
 *  图片数据（里面都是HMPhoto模型）
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  根据图片个数计算相册的最终尺寸
 */
- (CGSize)sizeWithPhotosCount:(NSUInteger)photosCount dynamic:(HMDynamic *)dynamic;

@end
