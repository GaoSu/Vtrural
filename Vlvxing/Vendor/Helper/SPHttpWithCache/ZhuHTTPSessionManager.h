//
//  ZhuHTTPSessionManager.h
//  ShiTingBang
//
//  Created by Michael on 16/11/2.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ZhuHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)shareManager;

@end
