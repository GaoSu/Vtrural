//
//  NSString+HD.m
//  HD
//
//  Created by Michael on 17/1/24.
//  Copyright © 2017年 zhuwencheng. All rights reserved.
//

#import "NSString+HD.h"

@implementation NSString (HD)

+ (void)hd_setNickName:(NSString *)nickName
{
      [[NSUserDefaults standardUserDefaults] setValue:nickName forKey:@"nickName"];
}

+ (NSString *)hd_getNickName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
}
+ (void )hd_removeIconStr
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"icon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void )hd_removeNickName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGSize)hd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font) {
        font = [UIFont systemFontOfSize:14];
    }
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[NSFontAttributeName] = font;
    
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = lineBreakMode;
        muDict[NSParagraphStyleAttributeName] = paraStyle;
    }
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:muDict context:nil];
    result = rect.size;
    return result;
}

- (CGFloat)hd_widthForFont:(UIFont *)font
{
    CGSize size = [self hd_sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)hd_heightForFont:(UIFont *)font
{
    CGSize size = [self hd_sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (BOOL)hd_isNotNull:(NSString *)checkString
{
    if (checkString == NULL||[checkString isKindOfClass:[NSNull class]]||[checkString isEqualToString:@"null"]||[checkString isEqualToString:@"(null)"]||checkString == nil||[checkString isEqualToString:@"<null>"]||[checkString isEqualToString:@""]||([checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)) {
        return NO;
    }else {
        return YES;
    }
}

- (NSString *)hd_transTimeStamp
{
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}

- (NSString *)hd_transTimeStamp:(NSString *)formatString
{
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
}

- (NSString *)hd_indexCharactor
{
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //多音字处理
    if ([[(NSString *)self substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)self substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)self substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)self substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([[(NSString *)self substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (void)hd_setDefaultToken:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"token"];
}
+(NSString*)hd_getMyPhoneNumberStr
{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"myPhoneStr"];
}
+(void)hd_removeMyPhoneNumberStr
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myPhoneStr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)hd_setMyIconStr:(NSData*)icon
{
    [[NSUserDefaults standardUserDefaults] setValue:icon forKey:@"icon"];
    
}
+ (NSData *)hd_getIconStr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"icon"];
}

+(void)hd_setMyPhoneNumberStr:(NSString*)phoneStr
{
    [[NSUserDefaults standardUserDefaults] setValue:phoneStr forKey:@"myPhoneStr"];

}
+ (NSString *)hd_getDefaultToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

+ (void)hd_setAlias:(NSString *)alias
{
    [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"alias"];
}

+ (NSString *)hd_getAlias
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
}

+ (void)hd_setDefaultUid:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"uid"];
}

+ (NSString *)hd_getDefaultUid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

+ (void )hd_removeDefaultToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void )hd_removeDefaultUserID
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)hd_getBaiduMapKey
{
    return @"";
}

+ (NSString *)hd_getUMKey
{
    return @"";
}

+ (NSString *)hd_partner
{
    return @"";
}

+ (NSString *)hd_seller
{
    return @"";
}

+ (NSString *)hd_privateKey
{
    return @"";
}

+ (NSString *)hd_openID
{
    return @"";
}

+ (NSString *)hd_package
{
    return @"Sign=WXPay";
}
+(void)hd_setCurrentCompanyName:(NSString*)companyName
{
    [[NSUserDefaults standardUserDefaults] setValue:companyName forKey:@"companyname"];
}

+(void)hd_setCurrentCompanyID:(NSString*)companyID
{
    [[NSUserDefaults standardUserDefaults] setValue:companyID forKey:@"companyid"];
}
+(void)hd_setCurrentCompanyPic:(NSString*)companyPic
{
    [[NSUserDefaults standardUserDefaults] setValue:companyPic forKey:@"companypic"];
}

+(NSString*)hd_getCurrentCompanyPic
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companypic"];
}

+(NSString*)hd_getCurrentCompanyName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companyname"];
    
}

+(NSString*)hd_getCurrentCompanyID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companyid"];
}
+(void)hd_removeCurrentCompanyName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companyname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)hd_removeCurrentCompanyID
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companyid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)hd_removeCurrentCompanyPic
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companypic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setYYCacheCompanyArr:(NSArray*)arr
{
    YYCache*cache=[[YYCache alloc]initWithName:@"compnayArr"];
    [cache setObject:arr forKey:@"companyArrKey"];
}

+(NSArray*)getYYCacheCompanyArr
{
    YYCache*cache=[[YYCache alloc]initWithName:@"compnayArr"];
     NSArray*arr=(NSArray*)[cache objectForKey:@"companyArrKey"];
    return arr;
}
+(void)removeYYCacheCurrentCompanyArr
{
      YYCache*cache=[[YYCache alloc]initWithName:@"compnayArr"];
      [cache removeAllObjects];
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark-- 正则匹配身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
//    BOOL flag;
//    if (identityCard.length <= 0) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
//    
    
    NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:identityCard]) return NO;
    // 省份代码。如果需要更精确的话，可以把六位行政区划代码都列举出来比较。
    NSString *provinceCode = [identityCard substringToIndex:2];
    NSArray *proviceCodes = @[@"11", @"12", @"13", @"14", @"15",
                              @"21", @"22", @"23",
                              @"31", @"32", @"33", @"34", @"35", @"36", @"37",
                              @"41", @"42", @"43", @"44", @"45", @"46",
                              @"50", @"51", @"52", @"53", @"54",
                              @"61", @"62", @"63", @"64", @"65",
                              @"71", @"81", @"82", @"91"];
    if (![proviceCodes containsObject:provinceCode]) return NO;
    
//    if (identityCard.length == 15) {
//        return [self validate15DigitsIDCardNumber:identityCard];
//    } else {
        return [self validate18DigitsIDCardNumber:identityCard];
//    }

    
    
    
    
    
}

/// 18位身份证号码验证。6位行政区划代码 + 8位出生日期码(yyyyMMdd) + 3位顺序码 + 1位校验码
+ (BOOL)validate18DigitsIDCardNumber:(NSString *)idNumber {
    NSString *birthday = [idNumber substringWithRange:NSMakeRange(6, 8)];
    if (![self validateBirthDate:birthday]) return NO;
    
    // 验证校验码
    int weight[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    
    int sum = 0;
    for (int i = 0; i < 17; i ++) {
        sum += [idNumber substringWithRange:NSMakeRange(i, 1)].intValue * weight[i];
    }
    int mod11 = sum % 11;
    NSArray<NSString *> *validationCodes = [@"1 0 X 9 8 7 6 5 4 3 2" componentsSeparatedByString:@" "];
    NSString *validationCode = validationCodes[mod11];
    
    return [idNumber hasSuffix:validationCode];
}

/// 验证出生年月日(yyyyMMdd)
+ (BOOL)validateBirthDate:(NSString *)birthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:birthDay];
    return date != nil;
}


#pragma mark-- 正则匹配邮箱号
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark 数组转化为json字符串
+(NSString *)ArrayChangeToJSONStr:(NSArray *)Arr{
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:Arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
//
#pragma mark---字典转化为json字符串
+(NSString *)DicChangeToJsonStr:(NSDictionary *)dic
{
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
//
+(void)hd_isPushGuangGao:(NSString*)str
{
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"isPush"];
}
+(NSString*)hd_getPushGuangGao
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"];
}

+(void)hd_buchong:(NSString*)str
{
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"buchong"];
}
+(NSString*)hd_getbuchong
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"buchong"];
}
+(void)removebuchong
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"buchong"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
