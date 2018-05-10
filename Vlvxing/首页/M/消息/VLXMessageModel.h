//
//  VLXMessageModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXMessageDataModel

@end
@interface VLXMessageModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXMessageDataModel> *data;
@end
@interface VLXMessageDataModel : JSONModel
@property (nonatomic, strong) NSNumber *msgid;
@property (nonatomic, strong) NSNumber *msgstatus;//未读消息状态
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
@property (nonatomic,strong)NSString *msgurl;
@property (nonatomic,strong)NSNumber * type;
@property (nonatomic,strong)NSString * iosclassname;//类名

//
@end
