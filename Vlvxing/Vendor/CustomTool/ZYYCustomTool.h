//
//  ZYYCustomTool.h
//  BaseProject
//
//  Created by 王静雨 on 2017/5/5.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYYCustomTool : NSObject
+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur;//动画弹出一个视图
+(id)checkNullWithNSString:(id)str;//返回字符串 如果是空 就是@""
+(UIImage *)getImage:(NSString *)filePath;//得到视频封面图
+(void)userToLoginWithVC:(UIViewController *)vc;//让用户登录
+(BOOL)checkDevice:(NSString*)name;
@end
