//
//  VLXMyOrderModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXMyOrderDataModel
@end
@interface VLXMyOrderModel : JSONModel//我的订单
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXMyOrderDataModel> *data;
@end
@interface VLXMyOrderDataModel : JSONModel
@property (nonatomic, strong) NSNumber *orderisdel;
@property (nonatomic, strong) NSNumber *orderprice;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, copy) NSString *ordername;
@property (nonatomic, copy) NSString *orderpic;
@property (nonatomic, copy) NSString *systemtradeno;
@property (nonatomic, copy) NSString *orderuseraddress;
@property (nonatomic, copy) NSString *orderuserid;
@property (nonatomic, strong) NSNumber *travelproductid;
@property (nonatomic, copy) NSString *orderusername;
@property (nonatomic, strong) NSNumber *orderid;
@property (nonatomic, strong) NSNumber *orderpaytype;
@property (nonatomic, copy) NSString *orderusermessage;
@property (nonatomic, strong) NSNumber *orderstatus;
@property (nonatomic, strong) NSNumber *ordercreatetime;
@property (nonatomic, strong) NSNumber *ordertype;
@property (nonatomic, copy) NSString *orderuserphone;
@property (nonatomic, strong) NSNumber *orderallprice;
@property (nonatomic, strong) NSNumber *ordercount;
//
@property (nonatomic,copy)NSString *orderaddresslat;
@property (nonatomic,copy)NSString *orderaddresslng;
@property (nonatomic,copy)NSString *outtradeno;
@end
