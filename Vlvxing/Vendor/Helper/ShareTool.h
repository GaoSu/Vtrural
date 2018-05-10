//
//  ShareTool.h
//  XWQY
//
//  Created by 王静雨 on 2017/4/24.
//  Copyright © 2017年 XWQY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
@interface ShareTool : NSObject
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andThumbURL:(NSString *)thumbUrl andTitle:(NSString *)title andDesc:(NSString *)desStr andWebPageUrl:(NSString *)webUrl;
@end
