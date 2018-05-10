//
//  UIColor+hexStringToColor.h
//  SmartCity
//
//  Created by handong on 15/9/7.
//  Copyright (c) 2015年 handong001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexStringToColor)
/**
 * 16进制颜色(html颜色值)字符串转为UIColor
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;


+(UIColor *)colorWithHexString: (NSString *) stringToConvert;


/**
 *  16进制颜色(html颜色值)字符串转为UIColor
 *
 *  @param stringToConvert 16进制颜色
 *  @param alpha           透明度
 *
 *  @return <#return value description#>
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert andAlph:(CGFloat)alpha;
@end
