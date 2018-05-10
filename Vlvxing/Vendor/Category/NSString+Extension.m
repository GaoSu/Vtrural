//
//  NSString+Extension.m
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

#define anHour  3600
#define aMinute 60

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**将时间戳转换为时间*/
- (NSString *)stringWithTimeStamp:(NSNumber *)timeStamp {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970] + 8 * anHour;
    //将传入的参数转化为时间戳
    double dateStamp = [timeStamp doubleValue] + 8 * anHour;
    //计算时间间隔，即当前时间减去传入的时间
    double interval = currentDateStamp - dateStamp;
    //获取当前时间的小时单位（24小时制）
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H"];
    int nowHour = [[formatter stringFromDate:currentDate] intValue];
    //获取当前时间的分钟单位
    NSDateFormatter *minFormatter = [NSDateFormatter new];
    [minFormatter setDateFormat:@"m"];
    int nowMinute = [[minFormatter stringFromDate:currentDate] intValue];
    //今天0点的时间戳
    double todayZeroClock = currentDateStamp - anHour * nowHour - aMinute * nowMinute;
    //时间格式化，为输出做准备
    NSDateFormatter *outputFormat = [NSDateFormatter new];
    [outputFormat setDateFormat:@"M月d日"];
    //进行条件判断，满足不同的条件返回不同的结果
    if (interval < 30 * aMinute) {
        //在30分钟之内
        return @"刚刚";
    } else if (todayZeroClock - dateStamp > 24 * anHour) {
        //已经超过两天以上
        return [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
    } else if (todayZeroClock - dateStamp > 0) {
        //已经超过一天（昨天）
        return @"昨天";
    } else if (interval < anHour) {
        //一个小时之内
        return [NSString stringWithFormat:@"%.0f分钟前", (currentDateStamp - dateStamp) / aMinute];
    } else {
        //今天之内
        return [NSString stringWithFormat:@"%.0f小时前", (currentDateStamp - dateStamp) / anHour];
    }
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)pinyin
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:pinyin];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}


@end
