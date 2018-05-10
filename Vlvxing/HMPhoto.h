//
//  HMPhoto.h
//  XingJu
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPhoto : NSObject
/** 缩略图 */
@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic, copy) NSString *bmiddle_pic;

//星聚
/** 原图 */
@property (nonatomic, copy) NSString *originalUrl;
/** 缩略图 */
@property (nonatomic, copy) NSString *url;
@end
