//
//  VLX_mine_fensi_model.h
//  Vlvxing
//
//  Created by grm on 2018/3/13.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_mine_fensi_model : NSObject


@property(nonatomic,strong)NSDictionary * followWhoMember;

+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
