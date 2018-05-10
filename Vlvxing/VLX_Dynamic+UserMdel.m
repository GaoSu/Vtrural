//
//  VLX_Dynamic+UserMdel.m
//  Vlvxing
//
//  Created by grm on 2018/1/17.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_Dynamic+UserMdel.h"

@implementation VLX_Dynamic_UserMdel

+(instancetype)infoListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
        NSLog(@"co~~~~ntent:%@",dict[@"dynamic"][@"content"]);//正确
    }
    return self;
}

//防止崩溃的(双方都有则赋值)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
