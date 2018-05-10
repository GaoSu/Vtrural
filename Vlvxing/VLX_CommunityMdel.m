//
//  VLX_CommunityMdel.m
//  Vlvxing
//
//  Created by grm on 2017/12/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_CommunityMdel.h"

@implementation VLX_CommunityMdel

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
