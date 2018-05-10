//
//  VLXMapTool.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMapTool.h"

@implementation VLXMapTool
+(CGFloat)calculateMeter:(CLLocationCoordinate2D)currentCoor toShop:(CLLocationCoordinate2D)shopCoor
{

    BMKMapPoint currentPoint=BMKMapPointForCoordinate(currentCoor);
    BMKMapPoint shopPoint=BMKMapPointForCoordinate(shopCoor);
    CLLocationDistance distance=BMKMetersBetweenMapPoints(currentPoint, shopPoint);
    return distance;
}
+(void)setMapCustomStyleWithNight
{
//    注：必须在BMKMapView对象初始化之前设置
    
    //个性化地图模板文件路径
    //custom_config_0323(黑夜)
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_0323(午夜蓝)" ofType:@""];
    
    //设置个性化地图样式
    
    [BMKMapView customMapStyle:path];
}
+(NSString *)changeLocationToStr:(NSArray<CLLocation *> *)locationArray
{
    //行程路径：格式："lng#lat-lng#lat-lng#lat-lng#lat"(lng经度，lat纬度)

    NSMutableArray *singleArray=[NSMutableArray array];
    for (int i=0; i<locationArray.count; i++) {
        CLLocation *location=locationArray[i];
        NSString *singleLocationStr=[NSString stringWithFormat:@"%f#%f",location.coordinate.longitude,location.coordinate.latitude];
        [singleArray addObject:singleLocationStr];
    }
    NSString *locationStr=[singleArray componentsJoinedByString:@"-"];
    return [ZYYCustomTool checkNullWithNSString:locationStr];
}
+(NSString *)changeEventArrayToJsonStr:(NSArray *)eventArray
{
    NSMutableArray *jsonArr=[NSMutableArray array];
    if (eventArray&&eventArray.count>0) {
        for (int i=0; i<eventArray.count; i++) {
            VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:eventArray[i]];
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:model.lng forKey:@"lng"];
            [dic setObject:model.lat forKey:@"lat"];
            [dic setObject:model.picUrl forKey:@"picUrl"];
            [dic setObject:model.videoUrl forKey:@"videoUrl"];
            [dic setObject:model.time forKey:@"time"];
            [dic setObject:model.pathName forKey:@"pathName"];
            [dic setObject:model.address forKey:@"address"];
            [dic setObject:[ZYYCustomTool checkNullWithNSString:model.coverUrl] forKey:@"coverUrl"];
            [jsonArr addObject:dic];
        }
        NSDictionary *dic=@{@"data":jsonArr};
        NSString *jsonStr=[NSString DicChangeToJsonStr:dic];
        return jsonStr;
    }
    return @"";
}
@end




















