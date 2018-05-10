//
//  VLX_photo.h
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_photo : NSObject

@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic, copy) NSString *bmiddle_pic;

/** 原图 */
@property (nonatomic, copy) NSString *originalUrl;
/** 缩略图 */
//@property (nonatomic, copy) NSString *url;

@end
