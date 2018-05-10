
//
//  VLX_User.m
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_User.h"

@implementation VLX_User

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userpic = [decoder decodeObjectForKey:@"userpic"];
        self.userid = [decoder decodeObjectForKey:@"userid"];
        self.usernick = [decoder decodeObjectForKey:@"usernick"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userpic forKey:@"userpic"];
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.usernick forKey:@"usernick"];

}

//- (BOOL)isVip
//{
//    // 是会员
//    return self.mbtype > 2;
//}


@end
