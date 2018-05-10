//
//  VLXRecordDetailModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@class VLXRecordDetailDataModel;
@protocol VLXRecordDetailInfoModel

@end
@interface VLXRecordDetailModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)VLXRecordDetailDataModel *data;
@end
@interface VLXRecordDetailDataModel : JSONModel
@property (nonatomic, copy) NSString *record_description;
@property (nonatomic, copy) NSString *startareaanddestination;
@property (nonatomic, strong) NSNumber *createtime;
@property (nonatomic, copy) NSString *destinationlng;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, copy) NSString *stratlat;
@property (nonatomic, strong) NSNumber *travelroadid;
@property (nonatomic, copy) NSString *travelroadtitle;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, copy) NSString *stratlng;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *coordinate;
@property (nonatomic, copy) NSString *destinationlat;
@property (nonatomic, copy) NSString *startarea;
//
@property (nonatomic,copy)NSString *authority;
@property (nonatomic,copy)NSString *distance;
@property (nonatomic,copy)NSString *isrecommend;
@property (nonatomic,strong)NSArray<VLXRecordDetailInfoModel> *pathinfos;
//
@end

@interface VLXRecordDetailInfoModel : JSONModel
@property (nonatomic, copy) NSString *videourl;
@property (nonatomic, copy) NSString *pathname;
@property (nonatomic, strong) NSNumber *createtime;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *pathlng;
@property (nonatomic, strong) NSNumber *travelroadid;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *pathlat;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *pathinfoid;
@property (nonatomic,copy)NSString *coverurl;
@end














