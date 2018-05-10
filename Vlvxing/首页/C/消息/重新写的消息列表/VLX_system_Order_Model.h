//
//  VLX_system_Order_Model.h
//  Vlvxing
//
//  Created by grm on 2017/12/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_system_Order_Model : NSObject


@property (nonatomic, strong) NSNumber *msgid;
@property (nonatomic, strong) NSNumber *msgstatus;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *msgtype;
@property (nonatomic, copy) NSString *msgcontent;
//
@property (nonatomic,copy)NSString *msgtime;
@property (nonatomic,copy)NSString *postid;
@property (nonatomic,copy)NSString *redirection;
@property (nonatomic,copy)NSString *targetid;
@property (nonatomic,strong)NSNumber *orderid;
@property (nonatomic,copy)NSString *titile;


+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
