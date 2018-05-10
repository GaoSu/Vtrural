//
//  VLXBusinessModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/2.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXBusinessDataModel
@end
@interface VLXBusinessModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXBusinessDataModel> *data;
@end
@interface VLXBusinessDataModel : JSONModel
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, copy) NSString *descraption;
@property (nonatomic, copy) NSString *pathlat;
@property (nonatomic, copy) NSString *pathlng;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, strong) NSNumber *businessid;
@property (nonatomic, copy) NSString *businessname;
//
@property (nonatomic,copy)NSString *businesspic;
@property (nonatomic,copy)NSString *businessproject;
//
@end
