//
//  VLXRecordImageDetailVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
#import "VLXRecordModel.h"
#import "VLXCourseModel.h"
#import "VLXRecordDetailModel.h"
@interface VLXRecordImageDetailVC : BaseViewController//图片详情
@property (nonatomic,strong)VLXRecordDataModel *model;//单个点
@property (nonatomic,strong)VLXCourseModel *courseModel;//录制中
@property (nonatomic,strong)VLXRecordDetailInfoModel *detailModel;//轨迹详情
@property (nonatomic,assign)BOOL isHiddenRight;//是否隐藏导航栏右上角图标
@end
