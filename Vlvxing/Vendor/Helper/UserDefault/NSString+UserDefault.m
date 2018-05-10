//
//  NSString+UserDefault.m
//  ShiTingBang
//
//  Created by zhuhmd on 16/11/2.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "NSString+UserDefault.h"

@implementation NSString (UserDefault)

+ (void)setDefaultToken:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"token"];
}

+ (NSString *)getDefaultToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

+ (void)setDefaultUser:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"userid"];
}

+ (NSString *)getDefaultUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}


+ (void)setAlias:(NSString *)alias
{
    [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"alias"];
}

+ (NSString *)getAlias
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
}

// 姓名
+ (void)setName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"name"];
}

+ (NSString *)getName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

// 手机
+ (void)setPhoneNum:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"phone"];
}

+ (NSString *)getPhone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
}

//地址

+ (void)setAddress:(NSString *)address
{
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:@"address"];
}

+ (NSString *)getAddress
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
}

// 身份证号
+ (void)setIdNum:(NSString *)idNum
{
    [[NSUserDefaults standardUserDefaults] setValue:idNum forKey:@"idNum"];
}

+ (NSString *)getIdNum
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"idNum"];
}

+ (void )removeDefaultToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
}

+ (BOOL)isNull:(NSString *)string
{
    if (string == NULL||[string isKindOfClass:[NSNull class]]||[string isEqualToString:@"null"]||[string isEqualToString:@"(null)"]||string == nil||[string isEqualToString:@"<null>"]||[string isEqualToString:@""]||([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)) {
        return YES;
    }else {
        return NO;
    }
}

//
+(NSString *)getCity
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
}
+(NSString *)getLatitude
{

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];

}
+(NSString *)getLongtitude
{
    

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"longtitude"];

}
+(NSString *)getAreaID
{

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"areaID"];

}
//
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)indexCharactor
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (NSString *)getBaiduMapKey
{
    return @"th98i2WDqNTYAZh7sGGfe3R2DpvBwax3";
}

+ (NSString *)getUMKey
{
    return @"582e79a9f43e481297001242";
}

- (NSString *)getFormatTime
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue] /1000];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *formatString = [formatter stringFromDate:timeDate];
    return formatString;
}

+ (NSString *)partner
{
    return @"2088621615946358";
}

+ (NSString *)seller
{
    return @"2757827556@qq.com";
}

+ (NSString *)privateKey
{
    return @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC3URT2N/Ijq1CeiaaF5kpSX3ns5nvZCsRqzdZA8tP8oF95vj34Qvde1A6tT/DTd2V8GSrfS0A45nDogYE1V3nA4b7SIfmA6YcXlsGhsuzZPjh48/BWDLwt+aKEVZ/G11ItODSHjBSVqqZ2b929x4JSZaooS5eWrHosKTUaAkcgDW6DOohGGgObTSC5mK3jPD/EFQiI87+sYvcEgUT+6kCpX5o8ix1tb1m8XiO1DlW3CHTFYlj7M9pRvrlfowJ0baiZe0U3X/fPHj1xTX73yhQfF0mueO74DChCJKIHhd/CvLS2Mtq+D/NC0Pbg4brEdHibOioOEnOii487brY9YZs9AgMBAAECggEAd06JAvpEWFyd+qCBxXGs+1FyS/Fxtz9fuFdA00J3H1rM6LIdKN+Ema4P41I83ZQ+c3b5xRv3r1CjOV9X1XyaHCOQCrjb5r+WEY8ndHK73WO2Y1n4GDjvnEh1MgV8GHB45j9HSNStbP8Emd6ShXo8Yh4SkWkpPoIAfY9QJR5IZh3dU1r38dd/KuVhiQcD/DhMbupeTlWFRHRnY2CteHvq5qkJPFI5BIRF1vYkHaQDvqkJ0l3alVpn9MJc22HtSrPmiZNHIkSnH45AZ0GhZRkS6OztaRngavHZaKi3JLKzPlkvL8NZcQMBysXzq+syE/1BnNj4/cMY/DzTWbat4FN4AQKBgQDlkCUQXq9SE+2KCncK146bBqFMUnoC5o/K3ERl4jTz0pEOZ9RK2v2aj0dTQweNYYMQcXhTyJN3fbc1NtrDrXJ9csuKRS2nLy5W0pqJkJ4XuXXYHXP/+axzGmtmFsWvXDElDow7SekO1qx+ugY1AzkTU3KgoUNcyfelRHkQUbTqAQKBgQDMbYb+MS8KUaKIDhKPW59Icnu3aDPXZb35gh29j3f4Xt1iMw49D0nftg2YRlTrVU5pUadC301IFSqTZlPEkwiIjNilqPTUMpkMGtk/OOf77ckEre9PwHA8HIFW5IBy8Y8ilQ9IfVy3/ErLgdwFSd6pjTfaDOpq4gakpS7lnOvZPQKBgBA0NomLRXDTu0atKm33fTdwJl6Oy9H8mFXHaoSOjRJQ4LBVn+SQxKnuRyiXaKcQJQI6IDY5yD78/rug3ZxGV/iG69scuvY8HFdAkmv3a1FdY/YXTiLZatTNHpucK+QO6+Ejv75Hn03O1Wo0k0+WpKa6kzLHb0vTbcmapbkDK3QBAoGAa6ozsqSMtc6Q3z8qHz6OAUXqSooi44q+Jy6UI0XwVWsBBbsGALqQmbX0KwK/rsHa7jUG9n1M4m3jYoY+EAWwNNqZL4Zwi2GqoWlyiY2bAGAXwtMoesRLWB1bMTxfOipmzDvdNLxxnKTPb6cRDef90SaDB+BNhcVM4mHs9RlUTbECgYB/clK1HaWJY7FJ7KUAKV0VfZkLYC8IMhjx0w3PkZC9z9uUPoLYOBPZnkL5a19gJUSIjOjV5EIWylTUR8lWmJI6cSZZF7mUU0y3/LhbtB1jXk0miLgE+BixunS5LGh66V4iWEmPU36wV8eFrPDIGyx7vyn3Zfn8UYM84nHBmGXT1A==";
}

+ (NSString *)openID
{

    return @"wxd3cb391989fe67f1";
}

+ (NSString *)package
{
    return @"Sign=WXPay";
}

@end
