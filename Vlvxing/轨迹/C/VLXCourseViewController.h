//
//  VLXCourseViewController.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
typedef enum : NSUInteger {
    MapNormal,//默认初始状态
    MapTrailStart,//开始录制轨迹
    MapSingleEvent,//单独拍照或者视频

    MapTrailEnd,//结束录制轨迹
    MapRouteSearch,//路线规划 

} MapStatus;
@interface VLXCourseViewController : BaseViewController

@end
