//
//  VLXRecordAnnotationView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "VLXRecordModel.h"
#import "VLXCourseModel.h"
#import "VLXRecordDetailModel.h"

@interface VLXRecordAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *annotationImageView;
@property (nonatomic,strong)UIImageView *iconImageView;//表示轨迹 图片 视频
@property (nonatomic,strong)UILabel *titleLab;//标题
-(void)createUIWithModel:(VLXRecordDataModel *)model;//用于记录
-(void)createUIWithCourseModel:(VLXCourseModel *)model;//用于轨迹
-(void)createUIWithRecordLine:(VLXRecordDetailInfoModel *)model;//用于轨迹线路
-(void)createUIWithGuijiModel:(VLXGuiJiModel *)model;
@end
