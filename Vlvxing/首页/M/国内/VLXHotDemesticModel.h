//
//  VLXHotDemesticModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXHotDemesticDataModel
@end
@interface VLXHotDemesticModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXHotDemesticDataModel> *data;
@end

@interface VLXHotDemesticDataModel : JSONModel
@property (nonatomic, strong) NSNumber *isforegin;
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, strong) NSNumber *hotspotsid;

@end
