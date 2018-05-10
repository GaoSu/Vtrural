//
//  VLXInputOrderModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLXInputOrderModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *address;

@property (nonatomic,copy)NSString *name1;
@property (nonatomic,copy)NSString *phone1;
@property (nonatomic,copy)NSString *address1;

@property (nonatomic,copy)NSString *IDCard;
@property (nonatomic,copy)NSString *others;//留言
@property (nonatomic,assign)NSInteger orderCount;//商品数量
@property (nonatomic,copy)NSString *allPrice;//总价
-(BOOL)checkIsFull;
-(BOOL)checkIsFull_2;//只判断姓名身份证
-(BOOL)checkIsFull_3;//只判断手机号
-(BOOL)checkIsFull_4;//姓名 电话 地址

@end
