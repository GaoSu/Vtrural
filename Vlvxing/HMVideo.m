
//
//  HMVideo.m
//  XingJu
//
//  Created by 中通华 on 16/11/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMVideo.h"

@implementation HMVideo

/** 视频信息 */
//@property (nonatomic,strong) HMVideo *video;

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
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
    [encoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [encoder encodeObject:self.videoId forKey:@"videoId"];
    [encoder encodeObject:self.vuid forKey:@"vuid"];
    
}

@end
