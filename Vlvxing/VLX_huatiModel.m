//
//  VLX_huatiModel.m
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_huatiModel.h"

@implementation VLX_huatiModel


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

-(CGFloat)CellHeight_ht{
    if (_CellHeight_ht) return _CellHeight_ht;

//    CGRect rect = [_content boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];

    CGFloat  iHeight = 0.0f;
    CGFloat  vHeight = 0.0f;
    CGFloat  wHeight = 0.0f;
    if ([self.content isEqualToString:@""]){

    }
    else{
        wHeight = 18.0f;
    }
    if (self.pictures.count!=0) { // 中间至少要显示1张图片
        iHeight=108.0f;////图片固定高度

    }
    if (self.videoUrl == nil) {
        vHeight=0.0f;
    }
    else{
        vHeight= ScreenWidth*9/16;//视频固定高度
    }
//    return  114 + rect.size.height + iHeight +vHeight;
    return  114 + wHeight + iHeight +vHeight;

}



@end
