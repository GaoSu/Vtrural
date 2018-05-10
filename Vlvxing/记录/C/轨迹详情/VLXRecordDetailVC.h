//
//  VLXRecordDetailVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLXRecordDetailVC : BaseViewController//轨迹详情
@property (nonatomic,copy)NSString *travelRoadId;//旅途id(旅途首页返回点中，如果travelRoadId有值就调这个方法，没有就不需要调用该接口，直接取之前途中点的返回值）
@end
