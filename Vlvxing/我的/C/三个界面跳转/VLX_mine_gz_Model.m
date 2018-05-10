//
//  VLX_mine_gz_Model.m
//  Vlvxing
//
//  Created by grm on 2018/3/13.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_mine_gz_Model.h"

@implementation VLX_mine_gz_Model
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
