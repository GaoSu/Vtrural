//
//  VLX_myOrderModel.m
//  Vlvxing
//
//  Created by grm on 2017/10/17.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_myOrderModel.h"

@implementation VLX_myOrderModel

+(instancetype)infoListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

//防止崩溃的(双方都有则赋值)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end
