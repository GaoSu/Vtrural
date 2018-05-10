//
//  ShareTool.m
//  XWQY
//
//  Created by 王静雨 on 2017/4/24.
//  Copyright © 2017年 XWQY. All rights reserved.
//

#import "ShareTool.h"

@implementation ShareTool

#pragma mark---分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andThumbURL:(NSString *)thumbUrl andTitle:(NSString *)title andDesc:(NSString *)desStr andWebPageUrl:(NSString *)webUrl
{
    // 判断是否安装了对应的app，如果未安装，添加一个提示
    if (platformType == UMSocialPlatformType_QQ) { // qq
       if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) { // 安装了
           
       }else{
           [SVProgressHUD showInfoWithStatus:@"您未安装qq"];
           return;
       }
        
    }else if (platformType == UMSocialPlatformType_Sina){ // 微博
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) { // 安装了
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"您未安装微博"];
            return;
        }
    }else if (platformType == UMSocialPlatformType_WechatSession){ // 微信
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"您未安装微信"];
            return;
        }
        
    }else if (platformType == UMSocialPlatformType_WechatTimeLine){ // 朋友圈
         if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"您未安装微信"];
            return;
        }
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    NSString* thumbURL = thumbUrl;// @"https://vlxingin.oss-cn-hangzhou.aliyuncs.com/image/201803/6d2c0816abf0493d2ef2233c61759378.jpg"; //  
    NSURL * imageurl=[NSURL URLWithString:thumbURL];
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desStr thumImage:thumbURL];
    NSLog(@"imageurl:::::%@",imageurl);

    //设置网页地址
//    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    shareObject.webpageUrl = webUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            MyLog(@"%@",error);
            //            HDLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}
#pragma mark
@end
