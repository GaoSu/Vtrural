//
//  NSString+WigthAndHeight.m
//  Xlx
//
//  Created by 陈一 on 15-6-12.
//  Copyright (c) 2015年 handong001. All rights reserved.
//

#import "NSString+WigthAndHeight.h"


@implementation NSString (WigthAndHeight)


//返回字符串所占用的尺寸.

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
       return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

@implementation NSString (ImagePath)

//-(NSString *)StringWithImagePath{
//    return [NSString stringWithFormat:@"%@%@",imagePath,self];
//}
//-(NSString *)StringWithImageTest{
//    return [NSString stringWithFormat:@"%@%@",imageTest,self];
//}

-(NSString *)StringwithBigImage{

    NSString * midImagePath=[NSString stringWithFormat:@"%@",self];
    NSString * mid=@"mid";
    NSRange rang=[midImagePath rangeOfString:mid];
    NSString * bigImagePath;
    if([midImagePath containsString:mid]){
       bigImagePath =[midImagePath stringByReplacingCharactersInRange:rang withString:@"big"];
    }
    return bigImagePath;
}

-(NSString *)StringwithSmalImage{
   
    NSString * midImagePath=[NSString stringWithFormat:@"%@",self];
    NSString * mid=@"mid";
    NSString * SmalImagePath;
    if([midImagePath containsString:mid]){
         NSRange rang=[midImagePath rangeOfString:mid];
         SmalImagePath=[midImagePath stringByReplacingCharactersInRange:rang withString:@"sma"];
    }
    return SmalImagePath;
}

-(NSString *)StringwithOriginalImage{
    
    NSString * OriginalImagePath;
    if (![self  isEqualToString:@""]) {
        NSString * midImagePath=[NSString stringWithFormat:@"%@",self];
        NSString * mid=@"_mid";
        if([midImagePath containsString:mid]){
            NSRange rang=[midImagePath rangeOfString:mid];
            OriginalImagePath=[midImagePath stringByReplacingCharactersInRange:rang withString:@""];
        }
    }
    
   return OriginalImagePath;
    
   
}



-(NSString *)clearString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor
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

- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}





//iOS生成一个32位的UUID
+ (NSString *)uuidString

{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    return [uuid lowercaseString];
    
}

//通过正则表达式获得图片
-(NSMutableAttributedString*)strChangeToImage
{
    
   NSMutableArray * biaoQingimageArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"biaoQingArr"];

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:self];
    //    NSLog(@"AAAAAAAAAAAAAAAAAAA====%@",self.textStr);
    // 创建正则表达式 然后匹配string
    NSString *pattern =@"\\[\\:emoji_\\w+\\:\\]";
    //根据正则表达式创建一个NSRegularExpression
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"error 1 :%@",[error localizedDescription]);
    }
    //5.0根据正则表达式匹配的结果从string字符串中获取需要替换的字符串
    NSArray *results = [regularExpression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange( 0,self.length)];
    //NSLog(@"符合正则的数:%d",results.count);
    //遍历数组
    for (int i = (int)results.count -1; i >= 0;i--)
    {
        
        NSTextCheckingResult *r = results[i];
        
        // 6.从图片数组中查找是否有与之匹配的表情
        
        for (int j = 0; j < biaoQingimageArr.count; j++) {
            
            //获取每个对象
            NSString*imageStr=biaoQingimageArr[j];
            //从string中获取当前需要替换的字符串
            NSString *tempStr = [self substringWithRange:r.range];
            //NSLog(@"++++%@",tempStr);
            NSInteger t = tempStr.length;
            NSRange range = {2,t-4};
            NSString *subTempStr1 = [tempStr substringWithRange:range];
            //7 有则替换
            if([subTempStr1 isEqualToString:imageStr])
            {
                //获取表情
                UIImage *image = [UIImage imageNamed:imageStr];
                //创建 附件
                NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
//                attachment.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
                attachment.bounds = CGRectMake(0, 0, 20, 20);
                attachment.image = image;
                //将attachment 转换成 attributedString
                NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:attachment];
                //替换
                [mutableAttributedString replaceCharactersInRange:r.range withAttributedString:att];
            }
        }
    }
    return mutableAttributedString;
}
-(NSString *)strChangeToImageName{

    NSString *imageName=nil;
    NSMutableArray * biaoQingimageArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"biaoQingArr"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:self];
    //    NSLog(@"AAAAAAAAAAAAAAAAAAA====%@",self.textStr);
    // 创建正则表达式 然后匹配string
    NSString *pattern =@"\\[\\:emoji_\\w+\\:\\]";
    //根据正则表达式创建一个NSRegularExpression
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"error 1 :%@",[error localizedDescription]);
    }
    //5.0根据正则表达式匹配的结果从string字符串中获取需要替换的字符串
    NSArray *results = [regularExpression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange( 0,self.length)];
    //NSLog(@"符合正则的数:%d",results.count);
    //遍历数组
    for (int i = (int)results.count -1; i >= 0;i--)
    {
        
        NSTextCheckingResult *r = results[i];
        
        // 6.从图片数组中查找是否有与之匹配的表情
        
        for (int j = 0; j < biaoQingimageArr.count; j++) {
            
            //获取每个对象
            NSString*imageStr=biaoQingimageArr[j];
            //从string中获取当前需要替换的字符串
            NSString *tempStr = [self substringWithRange:r.range];
            //NSLog(@"++++%@",tempStr);
            NSInteger t = tempStr.length;
            NSRange range = {2,t-4};
            NSString *subTempStr1 = [tempStr substringWithRange:range];
            //7 有则替换
            if([subTempStr1 isEqualToString:imageStr])
            {
                imageName=subTempStr1;
            }
        }
    }
    return imageName;
    
    

}



-(NSString *)strRplaceStr{

   NSString *prove = [self stringByReplacingOccurrencesOfString:@"省" withString:@""];
    prove =[prove stringByReplacingOccurrencesOfString:@"市" withString:@""];
    prove =[prove stringByReplacingOccurrencesOfString:@"自治区" withString:@""];

    return prove;
}



@end
