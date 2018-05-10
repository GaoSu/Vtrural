//
//  HMUser.m
//  XingJu
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMUser.h"

@implementation HMUser

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userHeadUrl = [decoder decodeObjectForKey:@"userHeadUrl"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userHeadUrl forKey:@"userHeadUrl"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    
}

- (BOOL)isVip
{
    // 是会员
    return self.mbtype > 2;
}

@end
