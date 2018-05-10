//
//  PayTool.h
//  hunhuibaomu
//
//  Created by RWN on 17/4/13.
//  Copyright © 2017年 RWN. All rights reserved.
//  支付工具

#import <Foundation/Foundation.h>


typedef void(^failureBlock)(NSString *errorInfo);

typedef void(^successfulBlock)();


@interface PayTool : NSObject

+(instancetype)defaltTool;
/*
 type   支付类型  1：微信  2：支付宝
 money  下单价格
 vipid  会员id
 */

-(void)payForServiceWithDic:(NSDictionary *)dataDic  withViewController:(UIViewController*)VC withPayType:(NSString*)payType SuccessBlock:(successfulBlock)success failure:(failureBlock)failure;


///郭荣明支付
-(void)grm_payforserveDic:(NSDictionary * )dataDic withVC:(UIViewController *)vc withPayType: (NSString *)payType SuccessBlock:(successfulBlock)success faile:(failureBlock)faile;

@end
