//
//  VLXRecordModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/2.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@class VLXGuiJiModel; // 轨迹数据模型
@protocol VLXRecordDataModel
@end
@protocol VLXGuiJiModel
@end
@interface VLXRecordModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXRecordDataModel> *data; // 标注点
@property(nonatomic,strong) NSArray<VLXGuiJiModel> *content; // 轨迹

@end
@interface VLXRecordDataModel : JSONModel
@property (nonatomic, copy) NSString *pathname;
@property (nonatomic, strong) NSNumber *createtime;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *pathlng;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *pathlat;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *pathinfoid;
//
@property (nonatomic,copy)NSString *travelroadid;
@property (nonatomic,copy)NSString *videourl;
@property (nonatomic,copy)NSString *coverurl;//封面图
@property(nonatomic,strong) NSString *countNum; // 下标


//
@end

@interface VLXGuiJiModel : JSONModel

@property(nonatomic,strong) NSString *authority;
@property(nonatomic,strong) NSString *coordinate;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *destination;
@property(nonatomic,strong) NSString *destinationlat;
@property(nonatomic,strong) NSString *destinationlng;
@property(nonatomic,strong) NSString *distance;
@property(nonatomic,strong) NSString *isdelete;
@property(nonatomic,strong) NSString *isrecommend;
@property(nonatomic,strong) NSString *startarea;
@property(nonatomic,strong) NSString *startareaanddestination;
@property(nonatomic,strong) NSString *stratlat;
@property(nonatomic,strong) NSString *stratlng;
@property(nonatomic,strong) NSString *travelroadid;
@property(nonatomic,strong) NSString *travelroadtitle;
@property(nonatomic,strong) NSString *userid;
@property(nonatomic,strong) NSString *countNum; // 下标

@end


