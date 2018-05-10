//
//  HMVideo.h
//  XingJu
//
//  Created by 中通华 on 16/11/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMVideo : NSObject<NSCoding>

/** 图片 */
@property (nonatomic,copy) NSString *imgUrl;
/** 视频id */
@property (nonatomic,copy) NSString *videoId;
/** 视频vuid */
@property (nonatomic,copy) NSString *vuid;

@end
