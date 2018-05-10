//
//  VLX_photo.m
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_photo.h"

@implementation VLX_photo

- (void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = [thumbnail_pic copy];

    //    self.bmiddle_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
