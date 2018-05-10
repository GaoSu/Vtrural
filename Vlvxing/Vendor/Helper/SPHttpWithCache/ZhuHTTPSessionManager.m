//
//  ZhuHTTPSessionManager.m
//  ShiTingBang
//
//  Created by Michael on 16/11/2.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "ZhuHTTPSessionManager.h"

@implementation ZhuHTTPSessionManager

+ (instancetype)shareManager
{
    static ZhuHTTPSessionManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [ZhuHTTPSessionManager manager];
        _shareManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _shareManager;
}

@end
