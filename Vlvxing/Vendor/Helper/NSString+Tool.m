//
//  NSString+Tool.m
//  guanjia
//
//  Created by hdkj005 on 16/7/12.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

-(NSString *)RwnTimeExchange{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}



-(NSString *)RwnTimeExchange1{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
     [formatter setDateStyle:NSDateFormatterMediumStyle];
//    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    formatter.dateFormat = @"YYYY.MM.dd HH:mm:ss";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}

-(NSString *)RwnTimeExchange2{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"hh:mm";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}
//
-(NSString *)RwnTimeExchange3{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"MM-dd";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}
-(NSString *)RwnTimeExchange4{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"YYYY/MM/dd";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}
-(NSString *)RwnTimeExchange5{
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}
//

+(NSString *)RwnTimeNow{

    NSDate *data=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"YYYY.MM.dd";
    NSString *sendStr = [formatter stringFromDate:data];
    return sendStr;
}

+(long long)RWNGetNowTimeInterval{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * timeStr=[formatter stringFromDate:currentDate];
    NSDate* date = [formatter dateFromString:timeStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    long long TimeChuo =  (long long)timeInterval * 1000;
    
    return TimeChuo;
}


+ (BOOL)checkForNull:(NSString *)checkString {
    if (checkString == NULL||[checkString isKindOfClass:[NSNull class]]||[checkString isEqualToString:@"null"]||[checkString isEqualToString:@"(null)"]||checkString == nil||[checkString isEqualToString:@"<null>"]||[checkString isEqualToString:@""]||([checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)) {
        return YES;
    }else {
        return NO;
    }
}

//+ (BOOL)checkForNullCHinese:(NSString *)checkString {//中文
//    int strlength = 0;
//    char* p = (char*)[checkString cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i=0 ; i<[checkString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//    }
//    return ((strlength/2)==1)?YES:NO;
//}


/**
 *  计算时间间隔
 *
 *  @param date 秒
 *
 *  @return 时间间隔
 */
+(NSString *)timeIntervalToNow:(long long)date
{
    NSDate *now=[NSDate date];
    NSNumber *time=[NSNumber numberWithLongLong:[now timeIntervalSince1970]*1000];
    long long nowTime=[time longLongValue]/1000;
    //1482904860 19542
    // 时间差
    long long   myTime=nowTime-date;
    //秒
    if (myTime<60) {
        
        return [NSString stringWithFormat:@"刚刚发表"];
    }
    //分钟
    long long mint=myTime/60;
    if (mint<60) {
        
        return [NSString stringWithFormat:@"%ld分钟前",mint];
    }
    //小时
    long long hour=myTime/(60*60);
    if (hour<24) {
        return [NSString stringWithFormat:@"%ld小时前",hour];
    }
    
    //天数
    long long day=myTime/(24*60*60);
    if (day<30) {
        return [NSString stringWithFormat:@"%ld天前",day];
    }
    
    
    //月
    long long month=myTime/(24*60*60*30);
    if (month<12) {
        return [NSString stringWithFormat:@"%ld月前",day];
    }
    
    return  nil;
}


//emoji去除
- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}




@end
