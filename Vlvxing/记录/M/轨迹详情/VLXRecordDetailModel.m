//
//  VLXRecordDetailModel.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordDetailModel.h"

@implementation VLXRecordDetailModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation VLXRecordDetailDataModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"record_description":@"description"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
@implementation VLXRecordDetailInfoModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
