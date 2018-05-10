//
//  VLXChooseAreaModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@class VLXChooseAreaDataModel;
@protocol VLXChooseAreaListModel

@end
@interface VLXChooseAreaModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)VLXChooseAreaDataModel *data;
@end
@interface VLXChooseAreaDataModel : JSONModel
@property (nonatomic,strong)NSArray<VLXChooseAreaListModel> *foreign;
@property (nonatomic,strong)NSArray<VLXChooseAreaListModel> *guonei;
@end

@interface VLXChooseAreaListModel : JSONModel
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, strong) NSNumber *isforegin;
@property (nonatomic, strong) NSNumber *ishot;
@property (nonatomic, strong) NSNumber *parentareaid;
@property (nonatomic, copy) NSString *areanamewithspell;
@property (nonatomic, strong) NSNumber *areaorderby;

@end
