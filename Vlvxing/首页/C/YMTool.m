//
//  YMTool.m
//  AiMoo
//
//  Created by Apple on 15/8/22.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "YMTool.h"
#import "AFNetworking.h"

@implementation YMTool


#pragma mark- 获取系统变量
//获取主appdelegate
+ (AppDelegate*)MyAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


#pragma mark 弹窗相关
//显示黑色等待弹窗
+ (MBProgressHUD*)openHUD:(NSString*)message view:(UIView*)myview
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[YMTool MyAppdelegate].window];
//      HUD.dimBackground=YES;
 
    [[YMTool MyAppdelegate].window addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.yOffset = -50.0f;
    [HUD show:YES];
    return HUD;
}
+ (void)closeHUD:(MBProgressHUD*)HUD
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
}
//显示黑色定时弹窗 view
+ (void)openIntervalHUD:(NSString*)message view:(UIView*)myview
{
    MBProgressHUD *HUD;
 
//    HUD = [[MBProgressHUD alloc] initWithWindow:[YMTool MyAppdelegate].window];
    
    HUD =[[MBProgressHUD alloc] initWithView:myview];
//    HUD.dimBackground=YES;
    [myview addSubview:HUD];
//    [[YMTool MyAppdelegate].window addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeText;

    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    HUD.yOffset = -50.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    
    }];
}
//显示黑色定时弹窗(带对勾的表示发表成功之类的)
+ (void)openIntervalHUDOK:(NSString*)message view:(UIView*)myview
{
    MBProgressHUD *HUD;
    

    HUD = [[MBProgressHUD alloc] initWithWindow:[YMTool MyAppdelegate].window];
    
//    HUD.dimBackground=YES;
    
    [[YMTool MyAppdelegate].window addSubview:HUD];
    
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"对号.png"]];
    HUD.yOffset = -50.0f;
 
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [HUD removeFromSuperview];

    }];
}


//函数功能：字符串判空
+(Boolean) isKongString:(NSString *) parmStr
{
    if (!parmStr) {
        return YES;
    }
    if ([parmStr isEqual:nil]) {
        return YES;
    }
    if ([parmStr isEqual:@""]) {
        return YES;
    }
    id tempStr=parmStr;
    if (tempStr==[NSNull null]) {
        return YES;
    }
    return NO;
}

//密码只能是6到20位的数字和字母组成，正则表达式
+(BOOL)isValidatePassword:(NSString *)passStr{
    
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:passStr];
    
    return isMatch;
    
}

//判断手机号码格式是否正确
+ (BOOL)isMobileNumber:(NSString *)mobileNum
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
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
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


+ (BOOL)isEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];

}


#pragma mark 验证身份证号码
+(BOOL)isIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

#pragma mark 通过文字,设置lab宽度 ()
+(CGFloat)getWidth:(NSString *)string font:(UIFont *)font{
    
//    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize labelSize = [string sizeWithFont:font
                          constrainedToSize:CGSizeMake(300, MAXFLOAT)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.width;
    
}

////通过文字,设置lab高度 ()
+(CGFloat)getHeight:(NSString *)string font:(UIFont *)font{
    
//    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize labelSize = [string sizeWithFont:font
                          constrainedToSize:CGSizeMake(300, MAXFLOAT)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height;
    
}

#pragma mark 四舍五入,处理数据
//number:需要处理的数字， position：保留小数点第几位，
+(NSString *)roundUp:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIImage *)BtnBackGroundImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//获取随机数
+(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{ //lng经度 lat纬度
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //    return  distance*1000;
    
    //返回 m
    return   distance/1000;
    
}


+ (NSDictionary *)jsonStringToNSDictionary:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic

{
    NSError *parseError = nil;
    if (dic == nil) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (void)saveStr:(NSString *)str forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:key];
    [defaults synchronize];
}

+ (NSString *)getStrUseKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:key]?[defaults objectForKey:key]:@"";
    return str;
}

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+(NSTimeInterval)compareTimeWithTime1:(NSString *)time1 time2:(NSString *)time2{
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate*date1=[dateFormatter dateFromString:time1];
    NSDate*date2=[dateFormatter dateFromString:time2];
    
    //两个时间相差(秒) //晚的时间在前
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    
    
    return time;
}

@end
