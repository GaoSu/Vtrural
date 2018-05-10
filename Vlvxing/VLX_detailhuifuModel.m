//
//  VLX_detailhuifuModel.m
//  Vlvxing
//
//  Created by grm on 2018/1/29.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_detailhuifuModel.h"

//#import "XHWebImageAutoSize.h"

//#import "NSString+Extension.h"
@implementation VLX_detailhuifuModel


//-(void)setValue:(id)value forKey:(NSString *)key
//{
//    if ([key isEqualToString:@"id"]) {
//        _PLid = value;
//    }
//
//}

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
-(CGFloat)CellHeight_2{
    if (_CellHeight_2) return _CellHeight_2;

    CGRect rect;
    if (_weiboComment == nil) {
//        NSLog(@"确实没有回复中的回复");
        rect = [_content boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    }
    else{
//        NSLog(@"确有回复中的回复");
        NSString * str2 = _weiboComment[@"content"];
        NSString * strALL = [NSString stringWithFormat:@"%@%@%@ %@",_content,@"@",_weiboComment[@"member"][@"usernick"],str2];

//        NSLog(@"strALL:%@",strALL);
        rect = [strALL boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    }
    //文字高度
    NSLog(@"Model中文字高度%f",rect.size.height);
    return  80 + rect.size.height;//+iHeight;



}
//- (CGFloat)heightForImage2:(UIImage *)image{
//    CGSize imgsize = image.size;
//    CGFloat scale = (ScreenWidth-20) / imgsize.width;
//    CGFloat imageHeight = imgsize.height * scale;
//    return imageHeight;
//
//}



@end

