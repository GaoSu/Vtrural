//
//  NSString+HD.h
//  HD
//
//  Created by Michael on 17/1/24.
//  Copyright © 2017年 zhuwencheng. All rights reserved.
//

@interface NSString (HD)

- (CGFloat)hd_heightForFont:(UIFont *)font;

- (CGFloat)hd_widthForFont:(UIFont *)font;

- (CGSize)hd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

+ (BOOL)hd_isNotNull:(NSString *)checkString;

- (NSString *)hd_transTimeStamp;

- (NSString *)hd_transTimeStamp:(NSString *)formatString;

- (NSString *)hd_indexCharactor;

+ (void)hd_setDefaultToken:(NSString *)value;

+ (NSString *)hd_getDefaultToken;

+ (void)hd_setAlias:(NSString *)alias;

+ (NSString *)hd_getAlias;

+ (void)hd_setNickName:(NSString *)nickName;

+ (NSString *)hd_getNickName;

+ (void )hd_removeNickName;

+ (void)hd_setDefaultUid:(NSString *)value;

+ (NSString *)hd_getDefaultUid;

+ (void )hd_removeDefaultToken;

+ (NSString *)hd_getBaiduMapKey;

+ (NSString *)hd_getUMKey;

+ (NSString *)hd_partner;

+ (NSString *)hd_seller;

+ (NSString *)hd_privateKey;

+ (NSString *)hd_openID;

+ (NSString *)hd_package;

+(void)hd_setCurrentCompanyName:(NSString*)companyName;

+(void)hd_setCurrentCompanyID:(NSString*)companyID;

+(NSString*)hd_getCurrentCompanyName;

+(NSString*)hd_getCurrentCompanyID;

- (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (void )hd_removeDefaultUserID;

+(void)hd_removeCurrentCompanyName;

+(void)hd_removeCurrentCompanyID;

+(void)hd_removeCurrentCompanyPic;

+(NSString*)hd_getMyPhoneNumberStr;

+(void)hd_setMyPhoneNumberStr:(NSString*)phoneStr;

+(void)hd_removeMyPhoneNumberStr;

+(void)hd_setCurrentCompanyPic:(NSString*)companyPic;

+(NSString*)hd_getCurrentCompanyPic;

+(void)setYYCacheCompanyArr:(NSArray*)arr;
+(NSArray*)getYYCacheCompanyArr;

+(void)removeYYCacheCurrentCompanyArr;
//6.验证是否是身份证号码
+ (BOOL)validateIdentityCard:(NSString *)identityCard;
//5.验证是否是邮箱
+ (BOOL)validateEmail:(NSString *)email;

+(NSString *)ArrayChangeToJSONStr:(NSArray *)Arr;
+(NSString *)DicChangeToJsonStr:(NSDictionary *)dic;
+(void)hd_isPushGuangGao:(NSString*)str;
+(NSString*)hd_getPushGuangGao;
+(void)hd_setMyIconStr:(NSData*)icon;
+ (NSData *)hd_getIconStr;
+ (void )hd_removeIconStr;
+(void)hd_buchong:(NSString*)str;
+(NSString*)hd_getbuchong;
+(void)removebuchong;
@end
