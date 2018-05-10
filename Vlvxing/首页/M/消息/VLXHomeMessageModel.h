//
//  VLXHomeMessageModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@protocol VLXHomeMessageDataModel
@end
@interface VLXHomeMessageModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)NSArray<VLXHomeMessageDataModel> *data;
@end
@interface VLXHomeMessageDataModel : JSONModel
@property (nonatomic, strong) NSNumber *hasNoRead;
//@property (nonatomic, strong) NSNumber *msgstatus;//系统消息未读状态,0未读,1已读

@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, strong) NSNumber *messageCount;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, strong) NSNumber *lastRecordTime;

@end
