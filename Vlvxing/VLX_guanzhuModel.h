//
//  VLX_guanzhuModel.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_guanzhuModel : NSObject
@property(nonatomic,strong)NSString * usernick;//
@property(nonatomic,strong)NSString * userpic;//
@property(nonatomic,strong)NSNumber * usersex;//
@property(nonatomic,strong)NSNumber * userid;

+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
