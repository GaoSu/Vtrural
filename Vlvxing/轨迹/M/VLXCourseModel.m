//
//  VLXCourseModel.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/7.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCourseModel.h"

@implementation VLXCourseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey :%@",key);
}
//归档 解档
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
         self.lng=[aDecoder decodeObjectForKey:@"lng"];
         self.lat=[aDecoder decodeObjectForKey:@"lat"];
         self.picUrl=[aDecoder decodeObjectForKey:@"picUrl"];
         self.videoUrl=[aDecoder decodeObjectForKey:@"videoUrl"];
         self.time=[aDecoder decodeObjectForKey:@"time"];
         self.pathName=[aDecoder decodeObjectForKey:@"pathName"];
         self.address=[aDecoder decodeObjectForKey:@"address"];
        self.coverUrl=[aDecoder decodeObjectForKey:@"coverUrl"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lng forKey:@"lng"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.picUrl forKey:@"picUrl"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.pathName forKey:@"pathName"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
}
//
-(void)removeModelAllValues
{
    _lng=0;
    _lat=0;
    _picUrl=nil;
    _videoUrl=nil;
    _coverUrl=nil;
    _time=nil;
    _pathName=nil;
    _address=nil;
}
@end
