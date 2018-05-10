//
//  VLXVHeadModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXVHeadDataModel
@end
@interface VLXVHeadModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXVHeadDataModel> *data;
@end

@interface VLXVHeadDataModel : JSONModel
@property (nonatomic, strong) NSNumber *areaid;
@property (nonatomic, strong) NSNumber *isstop;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, copy) NSString *headname;
@property (nonatomic, strong) NSNumber *vheadid;
@property (nonatomic, copy) NSString *vDescription;//原本是id,防止关键字冲突,使用其代替
//@property (nonatomic ,strong) NSString * description;
@property (nonatomic,copy)NSString *headpic;
@end
