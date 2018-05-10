//
//  NSString+WigthAndHeight.h
//  Xlx
//
//  Created by 陈一 on 15-6-12.
//  Copyright (c) 2015年 handong001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ImagePath)

-(NSString *)StringWithImagePath;
-(NSString *)StringWithImageTest;
-(NSString *)clearString;
-(NSString *)StringwithBigImage;
-(NSString *)StringwithSmalImage;
-(NSString *)StringwithOriginalImage;

@end


@interface NSString (WigthAndHeight)

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制该字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor;
/**
 *  禁止输入表情
 *
 *  @param text <#text description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)disable_emoji:(NSString *)text;

- (NSMutableAttributedString *)RWNdisable_emoji:(NSMutableAttributedString *)text;


+ (NSString *)uuidString;

-(NSMutableAttributedString*)strChangeToImage;
-(NSString *)strChangeToImageName;

-(NSString *)strRplaceStr;


@end
