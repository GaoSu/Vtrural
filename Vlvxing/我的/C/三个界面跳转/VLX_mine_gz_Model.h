//
//  VLX_mine_gz_Model.h
//  Vlvxing
//
//  Created by grm on 2018/3/13.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_mine_gz_Model : NSObject
@property(nonatomic,strong)NSString * usernick;//
@property(nonatomic,strong)NSString * userpic;//
@property(nonatomic,strong)NSNumber * usersex;//
@property(nonatomic,strong)NSNumber * userid;

+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
