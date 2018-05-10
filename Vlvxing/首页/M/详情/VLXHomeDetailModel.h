//
//  VLXHomeDetailModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@class VLXHomeDetailDataModel;
@interface VLXHomeDetailModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)VLXHomeDetailDataModel *data;
@end
@interface VLXHomeDetailDataModel : JSONModel
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, strong) NSNumber *endtime;
@property (nonatomic, strong) NSNumber *isfarmyard;
@property (nonatomic, strong) NSNumber *ishot;
@property (nonatomic, strong) NSNumber *isself;
@property (nonatomic, strong) NSNumber *istheme;
@property (nonatomic, strong) NSNumber *isvisa;
@property (nonatomic, strong) NSNumber *salecounts;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *pathlng;
@property (nonatomic, copy) NSString *feesdescription;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, strong) NSNumber *isgroup;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, strong) NSNumber *travelproductid;
@property (nonatomic, strong) NSNumber *isspecialprice;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *productbigpic;
@property (nonatomic, copy) NSString *pathlat;
@property (nonatomic, strong) NSNumber *starttime;
@property (nonatomic, strong) NSNumber *isfeature;
@property (nonatomic, strong) NSNumber *issessionplay;
@property (nonatomic, copy) NSString *productname;
@property (nonatomic, strong) NSNumber *isforeign;
@property (nonatomic, strong) NSNumber *specialprice;
@property (nonatomic, strong) NSNumber *areaid;
//
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *carinfotype;
@property (nonatomic,copy)NSString *cartimetype;
@property (nonatomic,copy)NSString *categoryid;
@property (nonatomic,copy)NSString *advertisebigpic;
@property (nonatomic,copy)NSString *productsmallpic;
@property (nonatomic,copy)NSString *traveltype;
@property (nonatomic,strong)NSNumber *distance;
@property(nonatomic,strong) NSString *context;

//
@end
