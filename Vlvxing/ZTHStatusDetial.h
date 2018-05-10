//
//  ZTHStatusDetial.h
//  XingJu
//
//  Created by 中通华 on 2017/1/10.
//  Copyright © 2017年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZTHStatusDetialDynamic,ZTHStatusDetialUser;

@interface ZTHStatusDetial : NSObject

/** 用户信息 */
@property (nonatomic,strong) ZTHStatusDetialUser *user;
/** 动态信息 */
@property (nonatomic,strong) ZTHStatusDetialDynamic *dynamic;

@end
