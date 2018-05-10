//
//  VLXMyDingZhiModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/2.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXMyDingZhiDataModel
@end
@interface VLXMyDingZhiModel : JSONModel//用于显示界面(我的定制)
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXMyDingZhiDataModel> *data;
@end
@interface VLXMyDingZhiDataModel : JSONModel
@property (nonatomic, copy) NSString *requirement;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, strong) NSNumber *departureid;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *peoplecounts;
@property (nonatomic, copy) NSString *departure;
@property (nonatomic, strong) NSNumber *customswimid;
@property (nonatomic, strong) NSNumber *days;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, strong) NSNumber *destinationid;
@property (nonatomic, strong) NSNumber *isstop;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mail;

@end
