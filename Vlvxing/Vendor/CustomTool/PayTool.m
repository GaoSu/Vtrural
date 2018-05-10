//
//  PayTool.m
//  hunhuibaomu
//
//  Created by RWN on 17/4/13.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import "PayTool.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "DataMD5.h"
//#import "UPPaymentControl.h"
#import "RSADataSigner.h"
@interface PayTool ()


@property(nonatomic,copy)NSString *orderid;//订单id
@property(nonatomic,copy)NSString *systemtradeno;//订单编号
@property(nonatomic,copy)NSString *totalFee;//钱数
@property(nonatomic,strong)PayTool *pay;



@end


@implementation PayTool

+(instancetype)defaltTool{

    static PayTool *tool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[self class] alloc];
     
    });
    return tool;
    
}

//
-(void)payForServiceWithDic:(NSDictionary *)dataDic  withViewController:(UIViewController*)VC withPayType:(NSString*)payType SuccessBlock:(successfulBlock)success failure:(failureBlock)failure{

    self.totalFee= dataDic[@"orderprice"]; // 订单金额
    self.orderid=[NSString stringWithFormat:@"%@",dataDic[@"orderid"]];
//    NSLog(@"%@*************%@",self.totalFee,self.orderid);
//    NSString *payMethod = [NSString stringWithFormat:@"%@",dataDic[@"paymethod"]];
    if ([payType isEqualToString:@"101"]) { // 微信
       [self payByWeiXinWithDataDic:dataDic SuccessBlock:success failure:failure];//跳转微信
    }else if ([payType isEqualToString:@"102"]){ // 支付宝
         [self payByZhiFuBaoWithDataDic:dataDic SuccessBlock:success failure:failure];//跳转支付宝
    }else if ([payType isEqualToString:@"103"]){ // 银联
//             [self yinlianPayWithVC:VC];
    }
}


#pragma mark--银联支付
//-(void)yinlianPayWithVC:(UIViewController*)VC
//
//{
//    //开始支付
//    /**
//     *  支付接口
//     *
//     *  @param tn             订单信息:找服务器要。
//     *  @param schemeStr      调用支付的app注册在info.plist中的scheme
//     *  @param mode           支付环境   //“00” 表示线上环境”01”表示测试环境
//     *  @param viewController 启动支付控件的viewController
//     *  @return 返回成功失败
//     */
//    [[UPPaymentControl defaultControl]
//     startPay:@"201610261856181495528"
//     fromScheme:@"PayProjectScheme://com.chj.cn"
//     mode:@"01"
//     viewController:VC];
//}

#pragma mark - 支付宝支付
-(void)payByZhiFuBaoWithDataDic:(NSDictionary *)dataDic SuccessBlock:(successfulBlock)success failure:(failureBlock)failure
{
    [SVProgressHUD showWithStatus:@"支付中"];

    if ([NSString checkForNull:self.orderid]) {
        [SVProgressHUD dismiss];
        return;
    }else
    {
        //重要说明
        //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
        //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
        //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
        /*============================================================================*/
        /*=======================需要填写商户app申请的===================================*/
        /*============================================================================*/
        NSString *appID = @"2017050307090883";
        // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
        // 如果商户两个都设置了，优先使用 rsa2PrivateKey
        // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
        // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
        // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
//        NSString *rsa2PrivateKey = [NSString privateKey];
//        NSString *rsaPrivateKey = @"";
        NSString *rsa2PrivateKey = @"";
        NSString *rsaPrivateKey = [NSString privateKey];//私钥
        /*============================================================================*/
        /*============================================================================*/
        /*============================================================================*/
        
        //partner和seller获取失败,提示
        if ([appID length] == 0 ||
            ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"缺少appId或者私钥。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = appID;
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        order.notify_url=[NSString stringWithFormat:@"%@%@",ftpPath,@"/aliPay/getnotify.html"];///hd
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
//        order.biz_content.body = @"我是测试数据";
//        order.biz_content.subject = @"testTitle";
        order.biz_content.body = @"V旅行";
        order.biz_content.subject=[ZYYCustomTool checkNullWithNSString:dataDic[@"servername"]];
        //        order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
        order.biz_content.out_trade_no = dataDic[@"systemtradeno"];
        order.biz_content.timeout_express = @"30m"; //超时时间设置30秒
        order.biz_content.total_amount =[NSString stringWithFormat:@"%.2f",[self.totalFee floatValue]] ; //商品价格
//        order.biz_content.total_amount = @"0.01";
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog_JSON(@"拼接orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        NSString *signedString = nil;
        RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
        if ((rsa2PrivateKey.length > 1)) {
            signedString = [signer signString:orderInfo withRSA2:YES];
        } else {
            signedString = [signer signString:orderInfo withRSA2:NO];
        }
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"ap2017050307090883";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog_JSON(@"支付宝结果%@",resultDic);//回diao
                if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000)
                {
                    [SVProgressHUD dismiss];
                    failure(@"支付成功");//郭荣明注
                }else {
                    [SVProgressHUD dismiss];
                    // failure(@"支付失败");
                    
                }
            }];
        }
        [SVProgressHUD dismiss];
        
    }
}
#pragma mark - 微信支付
- (void)payByWeiXinWithDataDic:(NSDictionary *)dataDic SuccessBlock:(successfulBlock)success failure:(failureBlock)failure
{
    if(![WXApi isWXAppInstalled])
    {
        [SVProgressHUD showInfoWithStatus:@"请先安装微信"];
    }else {

    if ([NSString checkForNull:self.orderid]) {
        return;
    }else {
         [SVProgressHUD showWithStatus:@"支付中"];
        NSString *urlStr=[NSString stringWithFormat:@"%@/wxpay/auth/placeOrder.json",ftpPath];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSString *totalFee = dataDic[@"orderprice"];
        NSString *systemNo = dataDic[@"systemtradeno"];
        NSString *countStr = [NSString stringWithFormat:@"%.0f",[totalFee floatValue]*100];
        
        [dic setObject:countStr forKey:@"total_fee"];
        [dic setObject:[NSString getDefaultToken] forKey:@"token"];
        [dic setObject:systemNo forKey:@"out_trade_no"];
//        [dic setValue:@"0" forKey:@"status"];
        [dic setObject:self.orderid forKey:@"order_id"];
        NSLog(@"%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            if ([requestDic[@"status"] intValue] == 1) {
                [SVProgressHUD dismiss];
                NSDictionary *dataDictionary = requestDic[@"data"];
                PayReq *wxPay = [[PayReq alloc] init];
                wxPay.openID = [NSString openID];
                wxPay.partnerId = [dataDictionary objectForKey:@"partner_id"];
                wxPay.prepayId = [dataDictionary objectForKey:@"prepay_id"];
                wxPay.nonceStr = [dataDictionary objectForKey:@"nonce_str"];
                wxPay.timeStamp = [[NSDate date] timeIntervalSince1970];
                wxPay.package = [NSString package];
                wxPay.sign = [[[DataMD5 alloc] init] createMD5SingForPay:wxPay.openID partnerid:wxPay.partnerId prepayid:wxPay.prepayId package:wxPay.package noncestr:wxPay.nonceStr timestamp:wxPay.timeStamp];
                [WXApi sendReq:wxPay];
                                MyLog(@"微信appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",wxPay.openID,wxPay.partnerId,wxPay.prepayId,wxPay.nonceStr,(long)wxPay.timeStamp,wxPay.package,wxPay.sign);
                success();
                
            }else {
                
                [SVProgressHUD dismiss];
                NSString *errorInfo=requestDic[@"message"];
                //   failure(errorInfo);
            }
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD dismiss];
        }];
    }
    }
}







@end
