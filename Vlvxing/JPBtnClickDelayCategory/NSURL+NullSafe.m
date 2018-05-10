//
//  NSURL+NullSafe.m
//  Vlvxing
//
//  Created by 刘 on 2018/5/10.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "NSURL+NullSafe.h"
#import <objc/message.h>
@implementation NSURL (NullSafe)

+ (void)load {
    Method imageNamedMethod = class_getClassMethod(self, @selector(URLWithString:));
    // 获取xmg_imageNamed
    Method xmg_imageNamedMethod = class_getClassMethod(self, @selector(safe_urlWithString:));
    
    // 交互方法:runtime
    method_exchangeImplementations(imageNamedMethod, xmg_imageNamedMethod);
    
}


+ (nullable instancetype)safe_urlWithString:(NSString *)string{
    
    if (string && ![string isKindOfClass:[NSNull class]]) {
        return  [self safe_urlWithString:string];
    }else{
       return  [self safe_urlWithString:@""];
    }
}


@end
