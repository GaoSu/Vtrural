//
//  VLXMapTool.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLXCourseModel.h"
@interface VLXMapTool : NSObject
+(CGFloat )calculateMeter:(CLLocationCoordinate2D)currentCoor toShop:(CLLocationCoordinate2D)shopCoor;////计算一个点离当前位置的距离
+(void)setMapCustomStyleWithNight;//设置地图是否夜间模式
+(NSString *)changeLocationToStr:(NSArray<CLLocation *> *)locationArray;//行程路径：格式："lng#lat-lng#lat-lng#lat-lng#lat"(lng经度，lat纬度)
+(NSString *)changeEventArrayToJsonStr:(NSArray<VLXCourseModel *> *)eventArray;
@end
