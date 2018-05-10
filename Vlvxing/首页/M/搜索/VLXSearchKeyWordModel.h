//
//  VLXSearchKeyWordModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/8.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXSearchKeyWordDataModel
@end
@interface VLXSearchKeyWordModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXSearchKeyWordDataModel> *data;
@end
@interface VLXSearchKeyWordDataModel : JSONModel
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, strong) NSNumber *isforegin;
@property (nonatomic, strong) NSNumber *parentareaid;
@property (nonatomic, copy) NSString *areanamewithspell;
@property (nonatomic, strong) NSNumber *areaorderby;
@property (nonatomic,copy)NSString *ishot;
@end
