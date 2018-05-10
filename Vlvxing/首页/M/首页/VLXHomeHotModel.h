//
//  VLXHomeHotModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXHomeHotDataModel
@end
@interface VLXHomeHotModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXHomeHotDataModel> *data;
@end

@interface VLXHomeHotDataModel : JSONModel
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, strong) NSNumber *isstop;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, strong) NSNumber *hotareaid;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic,strong)NSNumber *isforeign;

@end
