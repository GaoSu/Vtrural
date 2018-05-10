//
//  VLXVHeadModel.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXVHeadModel.h"

@implementation VLXVHeadModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation VLXVHeadDataModel
+ (JSONKeyMapper *)keyMapper
{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"jobid"}];
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"vDescription":@"description"}];//防止关键字冲突
}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
