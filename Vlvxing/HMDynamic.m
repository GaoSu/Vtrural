//
//  HMDynamic.m
//  XingJu
//
//  Created by 中通华 on 16/11/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMDynamic.h"
#import "HMVideo.h"
#import "MJExtension.h"
#import "HMPhoto.h"
#import "NSDate+MJ.h"
#import "RegexKitLite.h"
#import "HMRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"
#import "HMUser.h"

@interface HMDynamic ()
/** 日期 */
@property (nonatomic,strong) NSDateFormatter *fmt;

@end

@implementation HMDynamic

//照片模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"images" : [HMPhoto class]};
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.dynamicId = [decoder decodeObjectForKey:@"dynamicId"];
        self.collectionCount = [decoder decodeIntegerForKey:@"collectionCount"];
        self.collectionState = [decoder decodeBoolForKey:@"collectionState"];
        self.commentCount = [decoder decodeIntegerForKey:@"commentCount"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.date = [decoder decodeIntegerForKey:@"date"];
        self.likeCount = [decoder decodeIntegerForKey:@"likeCount"];
        self.likeState = [decoder decodeBoolForKey:@"likeState"];
        self.shareUrl = [decoder decodeObjectForKey:@"shareUrl"];
        self.currentPage = [decoder decodeIntegerForKey:@"currentPage"];
//        self.video = [decoder decodeObjectForKey:@"video"];
      
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.dynamicId forKey:@"dynamicId"];
    [encoder encodeInteger:self.collectionCount forKey:@"collectionCount"];
    [encoder encodeBool:self.collectionState forKey:@"collectionState"];
    [encoder encodeInteger:self.commentCount forKey:@"commentCount"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeInteger:self.date forKey:@"date"];
    [encoder encodeInteger:self.likeCount forKey:@"likeCount"];
    [encoder encodeInteger:self.currentPage forKey:@"currentPage"];
    [encoder encodeObject:self.shareUrl forKey:@"shareUrl"];
    [encoder encodeBool:self.likeState forKey:@"likeState"];
//    [encoder encodeObject:self.video forKey:@"video"];

}

/**
 *  根据字符串计算出所有的匹配结果（已经排好序）
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];

    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];

    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];

    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(HMRegexResult *rr1, HMRegexResult *rr2) {
        NSUInteger loc1 = rr1.range.location;
        NSUInteger loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    return regexResults;
}


- (void)setContent:(NSString *)content
{
    _content = [content copy];
    
    [self createAttributedText];
}





- (void)createAttributedText{
    if (self.content == nil) return;
    self.attributedText = [self attributedStringWithText:self.content];
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];

    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(HMRegexResult *result, NSUInteger idx, BOOL *stop) {
        HMEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [HMEmotionTool emotionWithDesc:result.string];
        }

        if (emotion) { // 如果有表情
            // 创建附件对象
            HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];

            // 传递表情
            attach.emotion = emotion;
            attach.bounds = CGRectMake(0, -3, HMStatusOrginalTextFont.lineHeight, HMStatusOrginalTextFont.lineHeight);

            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];

            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [result.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];

            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
            [result.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];

            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];

            [attributedString appendAttributedString:substr];
        }
    }];

    // 设置字体,主列表
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];



    NSLog(@"文字个数:%lu",(unsigned long)attributedString.length);



    return attributedString;
}


@end
