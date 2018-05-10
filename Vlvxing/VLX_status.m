
//
//  VLX_status.m
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_status.h"
#import "HMPhoto.h"
#import "RegexKitLite.h"
#import "HMRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"
#import "VLX_User.h"
@implementation VLX_status




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
//        self.collectionCount = [decoder decodeIntegerForKey:@"collectionCount"];
//        self.collectionState = [decoder decodeBoolForKey:@"collectionState"];
        self.commentcount = [decoder decodeIntegerForKey:@"commentCount"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.createTime = [decoder decodeIntegerForKey:@"date"];
        self.likeCount = [decoder decodeIntegerForKey:@"likeCount"];
        self.isFavor = [decoder decodeBoolForKey:@"likeState"];
//        self.shareUrl = [decoder decodeObjectForKey:@"shareUrl"];
        self.currentPage = [decoder decodeIntegerForKey:@"currentPage"];
        //        self.video = [decoder decodeObjectForKey:@"video"];

        self.imgUrl = [decoder decodeObjectForKey:@"imgUrl"];
        self.videoId = [decoder decodeObjectForKey:@"videoId"];
        self.vuid = [decoder decodeObjectForKey:@"vuid"];


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
//    [encoder encodeInteger:self.collectionCount forKey:@"collectionCount"];
//    [encoder encodeBool:self.collectionState forKey:@"collectionState"];
    [encoder encodeInteger:self.commentcount forKey:@"commentCount"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeInteger:self.createTime forKey:@"date"];
    [encoder encodeInteger:self.likeCount forKey:@"likeCount"];
    [encoder encodeInteger:self.currentPage forKey:@"currentPage"];
//    [encoder encodeObject:self.shareUrl forKey:@"shareUrl"];
    [encoder encodeBool:self.isFavor forKey:@"likeState"];
    //    [encoder encodeObject:self.video forKey:@"video"];

    [encoder encodeObject:self.imgUrl forKey:@"imgUrl"];//视频截图
    [encoder encodeObject:self.videoId forKey:@"videoId"];
    [encoder encodeObject:self.vuid forKey:@"vuid"];


}



@end
