//
//  VLXCourseModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/7.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLXCourseModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString *lng;//经度
@property (nonatomic,copy)NSString *lat;//纬度
@property (nonatomic,copy)NSString *picUrl;//图片url
@property (nonatomic,copy)NSString *videoUrl;//视频url
@property (nonatomic,copy)NSString *coverUrl;//视频封面图
@property (nonatomic,copy)NSString *time;//标注点保存时间
@property (nonatomic,copy)NSString *pathName ;//途中点名称
@property (nonatomic,copy)NSString *address ;//：地图获取的地点名称
-(void)removeModelAllValues;//清除model所有数据
@end
