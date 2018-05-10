//
//  VLXHomeAdsModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXHomeAdsDataModel
@end
@interface VLXHomeAdsModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXHomeAdsDataModel> *data;
@end

@interface VLXHomeAdsDataModel : JSONModel
@property (nonatomic, strong) NSNumber *adtype;
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, copy) NSString *adpicture;
@property (nonatomic, copy) NSString *adredirection;//轮播图 跳转URL
@property (nonatomic, strong) NSNumber *categoryid;//0首页，1国内，2国外
@property (nonatomic, strong) NSNumber *adid;//轮播图id
@property (nonatomic,copy)NSString *adcontents;//
@property (nonatomic,copy)NSString *adpostion;
@property (nonatomic,copy)NSString *adtitle;

@end
